//
//  FinanceGoalsTableViewCell.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

class FinanceGoalsTableViewCell: UITableViewCell {
    private lazy var nameGoalLabel = UILabel.create(fontSize: FontSizeConstans.heading, weight: .medium)
    private lazy var budgetGoalLabel = UILabel.create(fontSize: FontSizeConstans.body)
    private lazy var dateGoalLabel = UILabel.create(fontSize: FontSizeConstans.body)
    private lazy var resultLabel = UILabel.create(fontSize: FontSizeConstans.subbody)
    
    private lazy var nameBudgetStack = UIStackView.create(stackAxis: .horizontal, stackSpacing: Constans.smallStackSpacing,
                                                          stackDistribution: .equalSpacing,
                                             views: [nameGoalLabel, budgetGoalLabel])
    private lazy var dateProgressStack = UIStackView.create(stackSpacing: Constans.tinyStackSpacing,
                                                            views: [dateGoalLabel, progressBar, resultLabel])

    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressTintColor = UIColor(hex: ColorConstans.yellow)
        bar.progress = 0
        bar.layer.cornerRadius = Constans.cornerRadiusSmall
        return bar
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = Constans.cornerRadiusLarge
        view.layer.masksToBounds = true
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear 
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews(nameBudgetStack, dateProgressStack)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        nameBudgetStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        dateProgressStack.snp.makeConstraints { make in
            make.top.equalTo(nameBudgetStack.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.bottom.equalToSuperview().inset(Constans.insetSmall)
        }
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(Constans.smallHeight)
        }
    }
    
    func configureCell(finacialGoal: FinancialGoal) {
        nameGoalLabel.text = finacialGoal.name
        budgetGoalLabel.text = finacialGoal.sum + " ₽"
        dateGoalLabel.text = "\(R.string.localizable.dateGoalLabel()) \(Date.formated(date: finacialGoal.date))"
        switch finacialGoal.executionProcess {
        case .completed:
            resultLabel.isHidden = false
            resultLabel.text = R.string.localizable.positiveResult()
            resultLabel.textColor = .systemGreen
            progressBar.progress = 1
        case .failed:
            resultLabel.isHidden = false
            resultLabel.text = R.string.localizable.negativeResult()
            resultLabel.textColor = .systemRed
            progressBar.progress = 0
        case .progress:
            resultLabel.isHidden = true
            progressBar.setProgress(0.7, animated: false)
        }
    }
}

// MARK: reuseIndentifier
extension FinanceGoalsTableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
