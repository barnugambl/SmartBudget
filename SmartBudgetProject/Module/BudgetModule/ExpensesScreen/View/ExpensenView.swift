//
//  ExpensenVIew.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.06.2025.
//

import UIKit
import DGCharts

final class ExpensenView: UIView {
    var categories: [CategoryDto] = []

    var categoryViews: [CategoryItemView] = []
    
    var clickOnConfirmButton: (() -> Void)?
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.setupPersentLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    
    private lazy var scrollView = UIScrollView.create()
    
    private lazy var contentView = UIView()
    
    lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.drawEntryLabelsEnabled = false
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = true
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.7
        pieChart.drawEntryLabelsEnabled = true
        return pieChart
    }()
        
    private lazy var categoryStack = UIStackView.create(stackSpacing: Constans.mediumStackSpacing)
                                           
    private lazy var confirmButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmPersentButton())) { [weak self] in
        self?.clickOnConfirmButton?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupCategoryViews() {
        categories.forEach { category in
            let view = CategoryItemView(category: category, persentage: category.persentage, completion: nil)
            categoryViews.append(view)
            categoryStack.addArrangedSubview(view)
            
            view.snp.makeConstraints { make in
                make.height.equalTo(97)
            }
        }
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
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(categoryStack.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightButton)
            make.bottom.equalToSuperview().inset(Constans.insetTiny)
        }
    }
}
