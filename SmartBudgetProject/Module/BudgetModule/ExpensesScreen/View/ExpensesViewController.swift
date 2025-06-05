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
    private var categories: [CategoryDto] = []
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
        bindingViewModel()
        setupPieChart()
    }
    
    private func bindingViewModel() {
        viewModel.budgetService.initialBudgetSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] income, categories in
                guard let self else { return }
                self.expensesView.pieChartView.centerAttributedText = createCenterAttributedText(amount: income)
                self.categories = categories
                self.expensesView.categories = categories
                self.updatePieChart()
                self.expensesView.setupCategoryViews()
        }
        .store(in: &cancellable)
    }
    
    private func setupCategories() {
        expensesView.categories = categories
    }
    
    private func updateCategoriesFromViews() {
        categories = expensesView.categoryViews.map { view in
            let category = view.category
            return category
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = expensesView.titleLabel
        expensesView.clickOnConfirmButton = { [weak self] in
            guard let self else { return }
        }
    }
}

// MARK: SetupPieChartData
extension ExpensesViewController {
    func setupPieChart() {
        let entries = createPieChartEntries()
        let dataSet = createPieChartDataSet(with: entries)
        configurePieChart(with: dataSet)
    }
    
    func createPieChartEntries() -> [PieChartDataEntry] {
        return categories.map { category in
            let entry = PieChartDataEntry(value: Double(category.persentage))
            entry.label = category.name
            return entry
        }
    }
    
    private func updatePieChart() {
        let entries = createPieChartEntries()
        let newDataSet = createPieChartDataSet(with: entries)
        let chartData = PieChartData(dataSet: newDataSet)
        
        let rotationAngle = expensesView.pieChartView.rotationAngle
        let rotationEnabled = expensesView.pieChartView.rotationEnabled
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.8)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        
        expensesView.pieChartView.data = chartData
        
        CATransaction.commit()
        
        expensesView.pieChartView.rotationAngle = rotationAngle
        expensesView.pieChartView.rotationEnabled = rotationEnabled
    }
    
    func createPieChartDataSet(with entries: [PieChartDataEntry]) -> PieChartDataSet {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = categories.map({ $0.iconColor })
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
