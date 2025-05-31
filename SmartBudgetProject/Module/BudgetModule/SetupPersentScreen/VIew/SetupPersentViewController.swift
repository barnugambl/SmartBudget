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
    private var categories: [CategoryDto]
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
        
        persentView.categoryViews.forEach { categoryView in
            categoryView.sliderValue = { [weak self] in
                guard let self else { return }
                self.updateCategoriesFromViews()
                self.setupSliders()
                self.updatePieChart()
            }
        }
    }
    
    private func setupCategories() {
        persentView.categories = categories
    }
    
    private func updateCategoriesFromViews() {
        categories = persentView.categoryViews.map { view in
            var category = view.category
            category.persentage = Int(view.slider.value)
            return category
        }
    }
    
    private func setupSliders() {
        persentView.categoryViews.forEach { view in
            view.onPercentageChange = { [weak self] name, newValue in
                guard let self = self else { return false }
                return self.viewModel.canAdjustPercentage(for: self.categories, name: name, newPercentage: newValue)
            }
            view.sliderValue = { [weak self] in
                self?.updateCategoriesFromViews()
                self?.updatePieChart()
            }
        }
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
    
    private func updatePieChart() {
        let entries = createPieChartEntries()
        let newDataSet = createPieChartDataSet(with: entries)
        let chartData = PieChartData(dataSet: newDataSet)
        
        let rotationAngle = persentView.pieChartView.rotationAngle
        let rotationEnabled = persentView.pieChartView.rotationEnabled
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.8)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        
        persentView.pieChartView.data = chartData
        
        CATransaction.commit()
        
        persentView.pieChartView.rotationAngle = rotationAngle
        persentView.pieChartView.rotationEnabled = rotationEnabled
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
