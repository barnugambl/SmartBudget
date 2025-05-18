//
//  SetupPersentView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.05.2025.
//

import UIKit
import DGCharts

final class SetupPersentView: UIView {
    private var categories: [ItemView] = []
    
    var clickOnConfirmButton: (() -> Void)?
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.setupPersentLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    
    private lazy var scrollView = UIScrollView.create()
    
    private lazy var contentView = UIView()
    
    private lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.drawEntryLabelsEnabled = false
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = true
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.7
        pieChart.drawEntryLabelsEnabled = true
        return pieChart
    }()
        
    private lazy var productsCategoryView = ItemView(title: R.string.localizable.productsCategoryButton(),
                                                     iconName: R.image.food_icon.name,
                                                     iconColor: .systemGreen, isPersent: true)

    private lazy var transportCategoryView = ItemView(title: R.string.localizable.transportCategoryButton(),
                                                      iconName: R.image.transport_icon.name,
                                                      iconColor: .systemBlue, isPersent: true)

    private lazy var utilitiesCategoryView = ItemView(title: R.string.localizable.utilitiesCategoryButton(),
                                                      iconName: R.image.faucet_icon.name,
                                                      iconColor: .systemYellow, isPersent: true)

    private lazy var divorcesCategoryView = ItemView(title: R.string.localizable.divorcesCategoryButton(),
                                                     iconName: R.image.event_icon.name,
                                                     iconColor: .systemPurple, isPersent: true)

    private lazy var accumulationsCategoryView = ItemView(title: R.string.localizable.accumulationsCategoryButton(),
                                                          iconName: R.image.coins_icon.name,
                                                          iconColor: .systemOrange, isPersent: true)

    private lazy var otherCategoryView = ItemView(title: R.string.localizable.otherCategoryButton(),
                                                  iconName: R.image.other_icon.name,
                                                  iconColor: .systemGray, isPersent: true)
    
    private lazy var categoryStack = UIStackView.create(stackSpacing: Constans.mediumStackSpacing,
                                           views: [productsCategoryView, transportCategoryView, utilitiesCategoryView,
                                                                      divorcesCategoryView, accumulationsCategoryView, otherCategoryView])
   
    private lazy var confirmButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmPersentButton())) { [weak self] in
        self?.clickOnConfirmButton?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        distributeInitialPercents()
        setupPieChartData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(pieChartView, categoryStack, confirmButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        pieChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constans.insetSmall)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(250)
        }
        
        categoryStack.snp.makeConstraints { make in
            make.top.equalTo(pieChartView.snp.bottom).offset(Constans.insetLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            
        }
        
        categoryStack.arrangedSubviews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(Constans.heightItemView)
            }
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(categoryStack.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightButton)
            make.bottom.equalToSuperview().inset(Constans.insetTiny)
        }
    }
    
    private func distributeInitialPercents() {
        let categories = [productsCategoryView,
                          transportCategoryView,
                          utilitiesCategoryView,
                          divorcesCategoryView,
                          accumulationsCategoryView,
                          otherCategoryView]
        let basePercent = 100 / categories.count
        let remainder = 100 - (basePercent * categories.count)

        for (index, category) in categories.enumerated() {
            if index == categories.count - 1 {
                category.setPersent(basePercent + remainder)
            } else {
                category.setPersent(basePercent)
            }
        }
    }
}

// MARK: Setup PieChart
private extension SetupPersentView {
    private func setupPieChartData() {
        categories = [productsCategoryView, transportCategoryView, utilitiesCategoryView,
                      divorcesCategoryView, accumulationsCategoryView, otherCategoryView]
        
        let entries = categories.map { item in
                let percentText = item.persentLabel.text?.replacingOccurrences(of: "%", with: "") ?? "0"
                let percentValue = Double(percentText) ?? 0.0
                return PieChartDataEntry(value: percentValue, label: item.title)
        }
        
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = categories.map({ $0.iconColor })
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 10
        dataSet.selectionShift = 5

        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: FontSizeConstans.subbody, weight: .regular))
        pieChartView.data = data
    }
}
