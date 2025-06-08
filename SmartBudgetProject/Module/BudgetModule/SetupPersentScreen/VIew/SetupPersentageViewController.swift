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

final class SetupPersentageViewController: UIViewController {
    private var persentView = SetupPersentageView()
    weak var coordinator: OnboardingCoordinator?
    private let viewModel: SetupPersentageViewModel
    private var categories: [CategoryDto] = []
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(viewModel: SetupPersentageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        bindingViewModel()
        setupPieChart()
    }
    
    private func bindingViewModel() {
        viewModel.budgetService.initialBudgetSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] income, categories in
                guard let self else { return }
                self.persentView.pieChartView.centerAttributedText = createCenterAttributedText(amount: income)
                self.categories = categories
                self.persentView.categories = categories
                self.updatePieChart()
                self.persentView.setupCategoryViews()
                self.setupSliders()
            }
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                CustomToastView.showErrorToast(on: self.persentView, message: message)
            }
            .store(in: &cancellable)
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
                self.viewModel.resetError()
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
            guard viewModel.isFullPercentage(for: categories) else { return }
            viewModel.createBudget(
                income: self.persentView.pieChartView.centerAttributedText?.string ?? "",
                categories: categories) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.coordinator?.finishOnBoarding()                            
                        }
                    }
                }
        }
    }
}

// MARK: SetupPieChartData
extension SetupPersentageViewController {
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
        dataSet.colors = categories.map({ UIColor(hex: $0.iconColor) })
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
