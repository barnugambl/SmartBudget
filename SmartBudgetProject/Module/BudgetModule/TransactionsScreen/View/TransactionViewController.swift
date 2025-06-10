//
//  TransactionViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 09.06.2025.
//

import UIKit

enum TransactionTalbeViewSection {
    case main
}

final class TransactionViewController: UIViewController {
    private let name: String
    weak var coordinator: ExpensesCoordinator?
    private let viewModel: TransactionViewModel
    private let transactionView = TransactionView()
    private var diffableDataSource: UITableViewDiffableDataSource<TransactionTalbeViewSection, Transaction>?
    
    init(viewModel: TransactionViewModel, name: String) {
        self.viewModel = viewModel
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = transactionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDataSource()
        updateDataSource()
    }
    
    private func setupNavigationBar() {
        lazy var titleLabel = UILabel.create(text: name, fontSize: FontSizeConstans.title, weight: .medium)
        navigationItem.titleView = titleLabel
    }
}

// MARK: DataSource
extension TransactionViewController {
    private func setupDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(
            tableView: transactionView.table,
            cellProvider: { tableView, indexPath, itemIdentifier in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TransactionTableViewCell.reuseIdentifier,
                    for: indexPath) as? TransactionTableViewCell
                cell?.selectionStyle = .none
                
                let iconColor = self.viewModel.getIconColorByName(itemIdentifier.category)
                let iconName = self.viewModel.getIconName(itemIdentifier.category)
                cell?.configureCell(transaction: itemIdentifier, iconColor: iconColor, iconName: iconName)
                return cell
            })
    }
    
    private func updateDataSource() {
        let goals = viewModel.transaction.filter({ $0.category == name })
        var snaphot = NSDiffableDataSourceSnapshot<TransactionTalbeViewSection, Transaction>()
        snaphot.appendSections([.main])
        snaphot.appendItems(goals)
        diffableDataSource?.apply(snaphot, animatingDifferences: true)
        
    }
}
