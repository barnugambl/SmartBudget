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
    private var cancellables = Set<AnyCancellable>()
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
        setupDataSource()
        setupNavigationBar()
        setupTableDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFinancialGoals()
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
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.financialGoalsView.financialGoalsTableView.isHidden = true
                    self.financialGoalsView.loadIndicator.startAnimating()
                } else {
                    self.financialGoalsView.loadIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                self?.showAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ок", style: .default)
        alertController.addAction(actionOk)
        present(alertController, animated: true)
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
        updateDataSource()
    }
    
    private func updateDataSource() {
        let goals = viewModel.financialGoals
        var snaphot = NSDiffableDataSourceSnapshot<TableSection, Goal>()
        snaphot.appendSections([.main])
        snaphot.appendItems(goals)
        tableViewDataSource?.apply(snaphot)
        
    }
}

// MARK: TableViewDelegate
extension FinancialGoalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = viewModel.financialGoals[indexPath.row]
        coordinator?.showAddMoneyFinancialGoalFlow(nameGoal: currentItem.name, userId: viewModel.userId)
    }
}
