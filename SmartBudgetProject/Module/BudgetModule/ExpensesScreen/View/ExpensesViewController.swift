//
//  ExpensesViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.06.2025.
//

import UIKit
import Combine
import DGCharts

final class ExpensesViewController: UIViewController {
    private var expensesView = ExpensenView()
    weak var coordinator: ProfileCoordinator?
    private let viewModel: ExpensenViewModel
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(viewModel: ExpensenViewModel) {
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
        setupNavigationBar()
        updateCategoriesFromViews()
        setupPieChart()
    }
    
    private func updateCategoriesFromViews() {
        expensesView.categories = viewModel.categories
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = expensesView.titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(editTapped))
        
    }
    
    @objc private func editTapped() {
        coordinator?.showOnboardingFlow()
    }
}

// MARK: SetupPieChartData
extension ExpensesViewController {
    func setupPieChart() {
        let entries = createPieChartEntries()
        let dataSet = createPieChartDataSet(with: entries)
        configurePieChart(with: dataSet)
        self.expensesView.pieChartView.centerAttributedText = createCenterAttributedText(amount: viewModel.getIncomeString())
    }
    
    func createPieChartEntries() -> [PieChartDataEntry] {
        return viewModel.categories.map { category in
            let entry = PieChartDataEntry(value: Double(category.persentage))
            entry.label = category.name
            return entry
        }
    }
    
    func createPieChartDataSet(with entries: [PieChartDataEntry]) -> PieChartDataSet {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = viewModel.categories.map({ UIColor(hex: $0.iconColor) })
        dataSet.valueColors = [.black]
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 2
        dataSet.selectionShift = 5
        return dataSet
    }
    
    func configurePieChart(with dataSet: PieChartDataSet) {
        let chartData = PieChartData(dataSet: dataSet)
        expensesView.pieChartView.data = chartData
        expensesView.pieChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    func createCenterAttributedText(amount: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(
            string: "Бюджет\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: FontSizeConstans.body),
                .foregroundColor: UIColor.gray,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        centerText.append(
            NSAttributedString(
                string: amount,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: FontSizeConstans.title),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
            )
        )
        
        return centerText
    }
}
