//
//  BudgetViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 29.05.2025.
//

import Foundation
import UIKit
import Combine
import DGCharts

enum BudgetCategoryTableSection {
    case main
}

final class BudgetViewController: UIViewController {
    private var budgetView = BudgetView()
    private var viewModel: BudgetViewModel
    private var tableViewDataSource: UITableViewDiffableDataSource<BudgetCategoryTableSection, BudgetCategory>?
    private var cancellable: Set<AnyCancellable> = .init()
    weak var coordinator: ExpensesCoordinator?

    init(viewModel: BudgetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = budgetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        setupNavigationBar()
        budgetView.setupTableHeader()
        viewModel.fetchBudget()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
          budgetView.refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
      }
      
      @objc private func handleRefresh() {
          viewModel.refreshBudget()
      }
    
    private func bindingViewModel() {
        viewModel.budgetService.budgetSubject
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] budget in
                guard let self else { return }
                self.updateUI(budget: budget, colors: [.brown])
            }
            .store(in: &cancellable)
        
        viewModel.$budget
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] budget in
                guard let self else { return }
                self.viewModel.budgetService.budgetSubject.send(budget)
                self.updateUI(budget: budget, colors: [.link])
            }
            .store(in: &cancellable)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.budgetView.budgetCategoryTableView.isHidden = true
                    self.budgetView.loadIndicator.startAnimation()
                } else {
                    self.budgetView.budgetCategoryTableView.isHidden = false
                    self.budgetView.loadIndicator.stopAnimation()
                }
            }
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                CustomToastView.showErrorToast(on: self.budgetView, message: message)
                self.viewModel.resetMessages()
            }
            .store(in: &cancellable)
        
        viewModel.finishLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.budgetView.refreshControl.endRefreshing()
            }
        }
    }
    
    private func updateUI(budget: Budget, colors: [UIColor]) {
        setupPieChart(budget: budget, colors: colors)
        budgetView.pieChartView.centerAttributedText = budgetView.createCenterAttributedText(amount: "\(budget.income)")
        setupDataSource(budgetCategory: budget.categories)
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = budgetView.titleLabel
    }
    
}

// MARK: DataSource
extension BudgetViewController {
    private func setupDataSource(budgetCategory: [BudgetCategory]) {
        tableViewDataSource = UITableViewDiffableDataSource(
            tableView: budgetView.budgetCategoryTableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BudgetCategoryViewCell.reuseIdentifier,
                    for: indexPath) as? BudgetCategoryViewCell
                cell?.selectionStyle = .none
                cell?.configureCell(budgetCategory: itemIdentifier)
                return cell
            })
        updateDataSource(bugetCategory: budgetCategory)
    }
    
    private func updateDataSource(bugetCategory: [BudgetCategory]) {
        let goals = bugetCategory
        var snaphot = NSDiffableDataSourceSnapshot<BudgetCategoryTableSection, BudgetCategory>()
        snaphot.appendSections([.main])
        snaphot.appendItems(goals)
        tableViewDataSource?.apply(snaphot, animatingDifferences: false)
        
    }
}

// MARK: PieChartSetup
extension BudgetViewController {
    func setupPieChart(budget: Budget, colors: [UIColor]) {
        let entries = createPieChartEntries(budget: budget)
        let dataSet = createPieChartDataSet(with: entries, colors: colors)
        configurePieChart(with: dataSet)
    }
    
    func createPieChartEntries(budget: Budget) -> [PieChartDataEntry] {
        return budget.categories.map { category in
            let entry = PieChartDataEntry(value: Double(category.limit))
            entry.label = category.name
            return entry
        }
    }
    
    func createPieChartDataSet(with entries: [PieChartDataEntry], colors: [UIColor]) -> PieChartDataSet {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = colors
        dataSet.valueColors = [.black]
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 2
        dataSet.selectionShift = 5
        return dataSet
    }
    
    func configurePieChart(with dataSet: PieChartDataSet) {
        let chartData = PieChartData(dataSet: dataSet)
        budgetView.pieChartView.data = chartData
        budgetView.pieChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
}
