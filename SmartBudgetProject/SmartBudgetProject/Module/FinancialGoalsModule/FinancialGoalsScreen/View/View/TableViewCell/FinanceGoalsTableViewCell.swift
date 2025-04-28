//
//  FinanceGoalsTableViewCell.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

class FinanceGoalsTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameGoalLabel = Label(textSize: 20, weight: .medium)
    private lazy var budgetGoalLabel = Label(textSize: 16)
    private lazy var nameBudgetStack = Stack(stackAxis: .horizontal, stackSpaicing: 8,
                                             stackDistribution: .equalSpacing,
                                             views: [nameGoalLabel, budgetGoalLabel])
    
    private lazy var dateGoalLabel = Label(textSize: 16)
    private lazy var resultLabel = Label(textSize: 14)
    
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressTintColor = .systemYellow
        bar.progress = 0
        bar.layer.cornerRadius = 10
        return bar
    }()
    
    private lazy var dateProgressStack = Stack(stackSpaicing: 10, views: [dateGoalLabel, progressBar, resultLabel])
    
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
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nameBudgetStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateProgressStack.snp.makeConstraints { make in
            make.top.equalTo(nameBudgetStack.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(8)
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
            resultLabel.text =  R.string.localizable.negativeResult()
            resultLabel.textColor = .systemRed
            progressBar.progress = 0
        case .progress:
            resultLabel.isHidden = true
            progressBar.setProgress(0.7, animated: false)
        }
    }
}

extension FinanceGoalsTableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
