//
//  BudgetCategoryViewCell.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit

class BudgetCategoryViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameBudgetCategoryLabel = Label(textSize: 20, weight: .medium)
    private lazy var budgetSumLabel = Label(textSize: 24, weight: .medium)
    private lazy var plannedAmountLabel = Label(textSize: 14)
    private lazy var spentAmountLabel = Label(textSize: 14)
    
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressTintColor = UIColor(hex: "FFDD2D")
        bar.layer.cornerRadius = 10
        return bar
    }()
    
    private lazy var sumProgressStack = Stack(stackSpaicing: 5, views: [budgetSumLabel, progressBar])
    private lazy var amountStack = Stack(stackAxis: .horizontal, stackDistribution: .equalSpacing,
                                             views: [plannedAmountLabel, spentAmountLabel])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        
    }
    
    private func setupLayout() {
        contentView.addSubviews(containerView)
        containerView.addSubviews(nameBudgetCategoryLabel, sumProgressStack, amountStack)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nameBudgetCategoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        sumProgressStack.snp.makeConstraints { make in
            make.top.equalTo(nameBudgetCategoryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        amountStack.snp.makeConstraints { make in
            make.top.equalTo(sumProgressStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(8)
        }
    }
    
    func configureCell(budgetCategory: BudgetCategory) {
        nameBudgetCategoryLabel.text = budgetCategory.name
        budgetSumLabel.text = "\(budgetCategory.plannedAmount) ₽"
        plannedAmountLabel.text = "Потрачено \(budgetCategory.spentAmount) ₽"
        spentAmountLabel.text = "Осталось \(budgetCategory.remainingAmount) ₽"
        
        let progress = Float(budgetCategory.spentAmount) / Float(budgetCategory.plannedAmount)
        progressBar.setProgress(progress, animated: false)
    }
}

extension BudgetCategoryViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
