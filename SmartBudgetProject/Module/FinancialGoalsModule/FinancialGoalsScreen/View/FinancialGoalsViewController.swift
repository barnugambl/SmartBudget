//
//  FinancialGoalsViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import UIKit
import Combine

enum TableSection {
    case main
}

final class FinancialGoalsViewController: UIViewController {
    private var viewModel: FinancialGoalViewModel
    private var financialGoalsView = FinancialGoalsView()
    private var tableViewDataSource: UITableViewDiffableDataSource<TableSection, Goal>?
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: FinancialGoalCoordinator?
    
    init(viewModel: FinancialGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = financialGoalsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchFinancialGoals()
        setupDataSource()
        setupNavigationBar()
        setupTableDelegate()
        bindViewModel()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        financialGoalsView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        financialGoalsView.financialGoalsTableView.refreshControl = self.financialGoalsView.refreshControl
    }
    
    @objc private func refreshData() {
        viewModel.refreshFinancialGoals()
    }
    
    private func bindViewModel() {
        viewModel.$financialGoals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateDataSource()
                if !self.viewModel.isLoading {
                    self.financialGoalsView.showTable()
                }
            }
            .store(in: &cancellable)
        
        viewModel.financialGoalService.addGoalSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goal in
                guard let self else { return }
                self.viewModel.financialGoals.append(goal)
                self.updateDataSource()
            }
            .store(in: &cancellable)
        
        viewModel.finishLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.financialGoalsView.refreshControl.endRefreshing()
            }
        }
        
        viewModel.financialGoalService.updateGoalSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goal in
                guard let self else { return }
                if let index = self.viewModel.financialGoals.firstIndex(where: { $0.goalId == goal.goalId }) {
                    self.viewModel.financialGoals[index] = goal
                    viewModel.updateGoalToCoreDate(goal: goal)
                    self.updateDataSource()
                }
            }
            .store(in: &cancellable)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.financialGoalsView.financialGoalsTableView.isHidden = true
                    self.financialGoalsView.loadIndicator.startAnimation()
                } else {
                    self.financialGoalsView.loadIndicator.stopAnimation()
                }
            }
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                CustomToastView.showErrorToast(on: self.financialGoalsView, message: message)
            }
            .store(in: &cancellable)
        
        viewModel.$successMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                CustomToastView.showSuccessToast(on: self.financialGoalsView, message: message)
            }
            .store(in: &cancellable)
        
        viewModel.financialGoalService.successMessageSubject
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                CustomToastView.showSuccessToast(on: self.financialGoalsView, message: message)
            }
            .store(in: &cancellable)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel.create(text: R.string.localizable.financialGoalsLabel(), fontSize: FontSizeConstans.title,
                                        weight: .medium)
        navigationItem.titleView = titleLabel
        
        let action = UIAction { [weak self] _ in
            self?.coordinator?.showAddFinancialGoalFlow()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    private func setupTableDelegate() {
        financialGoalsView.financialGoalsTableView.delegate = self
    }
}

// MARK: DiffableDataSource
extension FinancialGoalsViewController {
    private func setupDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource(
            tableView: financialGoalsView.financialGoalsTableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FinanceGoalsTableViewCell.reuseIdentifier,
                    for: indexPath) as? FinanceGoalsTableViewCell
                cell?.selectionStyle = .none
                cell?.configureCell(finacialGoal: itemIdentifier)
                return cell
            })
    }
    
    private func updateDataSource() {
        let goals = viewModel.financialGoals
        var snaphot = NSDiffableDataSourceSnapshot<TableSection, Goal>()
        snaphot.appendSections([.main])
        snaphot.appendItems(goals)
        tableViewDataSource?.apply(snaphot, animatingDifferences: true)
        
    }
}

// MARK: TableViewDelegate
extension FinancialGoalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let goal = viewModel.financialGoals[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            if goal.status == .inProgress {
                let deleteAction = UIAction(title: R.string.localizable.contextMenuDelete(),
                                            image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.viewModel.deleteFinancialGoal(goalId: goal.goalId)
                }
                
                let editAction = UIAction(title: R.string.localizable.contextMenuEdit(),
                                          image: UIImage(systemName: "pencil")) { [weak self] _ in
                    self?.coordinator?.showEditFinancialGoal(goal: goal)
                }
                
                let addMoneyAction = UIAction(title: R.string.localizable.contextMenuAddMoney(),
                                              image: UIImage(systemName: "plus.circle")) { [weak self] _ in
                    self?.coordinator?.showAddMoneyFinancialGoalFlow(goal: goal)
                }
                return UIMenu(title: "", children: [addMoneyAction, editAction, deleteAction])
                
            } else {
                let deleteAction = UIAction(title: R.string.localizable.contextMenuDelete(),
                                            image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.viewModel.deleteFinancialGoal(goalId: goal.goalId)
                }
                return UIMenu(title: "", children: [deleteAction])
            }
            
        }
    }
}
