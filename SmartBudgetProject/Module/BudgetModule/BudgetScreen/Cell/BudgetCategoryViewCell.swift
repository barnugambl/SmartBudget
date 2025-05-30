//
//  BudgetCategoryViewCell.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit

final class BudgetCategoryViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = BudgetCategoryViewCell.containerCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameBudgetCategoryLabel = UILabel.create(fontSize: FontSizeConstans.heading, weight: .medium)
    private lazy var budgetSumLabel = UILabel.create(fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var plannedAmountLabel = UILabel.create(fontSize: FontSizeConstans.subbody)
    private lazy var spentAmountLabel = UILabel.create(fontSize: FontSizeConstans.subbody)
    
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressTintColor = UIColor(hex: ColorConstans.yellow)
        bar.layer.cornerRadius = BudgetCategoryViewCell.progressBarCornerRadius
        return bar
    }()
    
    private lazy var sumProgressStack = UIStackView.create(stackSpacing: Constans.tinyStackSpacing, views: [budgetSumLabel, progressBar])
    private lazy var amountStack = UIStackView.create(stackAxis: .horizontal, stackDistribution: .equalSpacing,
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
            make.top.bottom.equalToSuperview().inset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        nameBudgetCategoryLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Constans.insetSmall)
        }
        
        sumProgressStack.snp.makeConstraints { make in
            make.top.equalTo(nameBudgetCategoryLabel.snp.bottom).offset(Constans.insetSmall)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        amountStack.snp.makeConstraints { make in
            make.top.equalTo(sumProgressStack.snp.bottom).offset(Constans.insetSmall)
            make.leading.trailing.bottom.equalToSuperview().inset(Constans.insetSmall)
        }
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(BudgetCategoryViewCell.heightProgrssBar)
        }
    }
    
    func configureCell(budgetCategory: BudgetCategory) {
        nameBudgetCategoryLabel.text = budgetCategory.name
        budgetSumLabel.text = "\(budgetCategory.limit) ₽"
        plannedAmountLabel.text = "\(R.string.localizable.spentLabel()) \(budgetCategory.spent) ₽"
        spentAmountLabel.text = "\(R.string.localizable.remainingLabel()) \(budgetCategory.remaining) ₽"
        
        let progress = Float(budgetCategory.spent) / Float(budgetCategory.limit)
        progressBar.setProgress(progress, animated: false)
    }
}

// MARK: reuseIdentifier
extension BudgetCategoryViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

// MARK: Constans
private extension BudgetCategoryViewCell {
    static let heightProgrssBar: CGFloat = 8
    static let containerCornerRadius: CGFloat = 20
    static let progressBarCornerRadius: CGFloat = 10
}
