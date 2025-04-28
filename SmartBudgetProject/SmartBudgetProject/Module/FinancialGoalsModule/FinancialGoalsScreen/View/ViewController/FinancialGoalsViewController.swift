//
//  FinancialGoalsViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import UIKit

enum TableSection {
    case main
}

class FinancialGoalsViewController: UIViewController {
    private var viewModel: FinancialGoalViewModel
    private var financialGoalsView = FinancialGoalsView()
    private var tableViewDataSource: UITableViewDiffableDataSource<TableSection, FinancialGoal>?
    weak var coordinator: AppCoordinator?

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
    }
    
    private func setupNavigationBar() {
        let titleLabel = Label(textLabel: "Мои финансовые цели",textSize: 24, weight: .medium)
        navigationItem.titleView = titleLabel
        
        let action = UIAction { [weak self] _ in
            self?.coordinator?.showAddFinancialGoalScreen()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
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
        var snaphot = NSDiffableDataSourceSnapshot<TableSection, FinancialGoal>()
        snaphot.appendSections([.main])
        snaphot.appendItems(goals)
        tableViewDataSource?.apply(snaphot)
        
    }
}
