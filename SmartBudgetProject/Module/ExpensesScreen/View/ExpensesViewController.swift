//
//  ExpensesViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 25.04.2025.
//

import Foundation
import UIKit

enum BudgetCategoryTableSection {
    case main
}

final class ExpensesViewController: UIViewController {
    private var expensesView = ExpensesView()
    private var viewModel: ExpensesViewModel
    private var tableViewDataSource: UITableViewDiffableDataSource<BudgetCategoryTableSection, BudgetCategory>?
    weak var coordinator: ExpensesCoordinator?

    init(viewModel: ExpensesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = expensesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = expensesView.titleLabel
    }
}

// MARK: DataSource
extension ExpensesViewController {
    private func setupDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource(
            tableView: expensesView.budgetCategoryTableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BudgetCategoryViewCell.reuseIdentifier,
                    for: indexPath) as? BudgetCategoryViewCell
                cell?.selectionStyle = .none
                cell?.configureCell(budgetCategory: itemIdentifier)
                return cell
            })
        updateDataSource()
    }
    
    private func updateDataSource() {
        let goals = viewModel.financialGoals
        var snaphot = NSDiffableDataSourceSnapshot<BudgetCategoryTableSection, BudgetCategory>()
        snaphot.appendSections([.main])
        snaphot.appendItems(goals)
        tableViewDataSource?.apply(snaphot)
        
    }
}
