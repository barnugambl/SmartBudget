//
//  SetupPersentViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.05.2025.
//

import Foundation
import UIKit
import DGCharts
import Combine

final class SetupPersentViewController: UIViewController {
    private var persentView = SetupPersentView()
    weak var coordinator: OnboardingCoordinator?
    private let viewModel: BudgetViewModel
    private let categories: [CategoryDto]
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(viewModel: BudgetViewModel, categories: [CategoryDto]) {
        self.viewModel = viewModel
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
        setupCategories()
        persentView.setupCategoryViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = persentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupPieChart()
        bindingViewModel()
        
    }
    
    private func bindingViewModel() {
        viewModel.$incomeString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] amount in
                guard let self else { return }
                self.persentView.pieChartView.centerAttributedText = createCenterAttributedText(amount: amount)
        }
        .store(in: &cancellable)
    }
        
    private func setupCategories() {
        persentView.categories = categories
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = persentView.titleLabel
        
        persentView.clickOnConfirmButton = { [weak self] in
            guard let self else { return }
            viewModel.createBudget(categories: categories)
            self.coordinator?.finishOnBoarding()
        }
    }
}

// MARK: SetupPieChartData
extension SetupPersentViewController {
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
        persentView.pieChartView.data = chartData
        persentView.pieChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    func createCenterAttributedText(amount: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(
            string: "\(R.string.localizable.pieChartLabel)\n",
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
