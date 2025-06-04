//
//  FinanceGoalsTableViewCell.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

class FinanceGoalsTableViewCell: UITableViewCell {
    private lazy var nameGoalLabel = UILabel.create(fontSize: FontSizeConstans.heading, weight: .medium)
    private lazy var targetAmountLabel = UILabel.create(fontSize: FontSizeConstans.body)
    private lazy var dateGoalLabel = UILabel.create(fontSize: FontSizeConstans.body)
    private lazy var resultLabel = UILabel.create(fontSize: FontSizeConstans.subbody)
    private lazy var savedAmountLabel = UILabel.create(fontSize: FontSizeConstans.subbody)
    private lazy var remainderLabel = UILabel.create(fontSize: FontSizeConstans.subbody)
    
    private lazy var nameBudgetStack = UIStackView.create(stackAxis: .horizontal, stackSpacing: Constans.smallStackSpacing,
                                                          stackDistribution: .equalSpacing,
                                             views: [nameGoalLabel, targetAmountLabel])
    private lazy var dateProgressStack = UIStackView.create(stackSpacing: Constans.tinyStackSpacing,
                                                            views: [dateGoalLabel, progressBar])
    private lazy var savedRemainderStack = UIStackView.create(stackAxis: .horizontal, stackDistribution: .equalSpacing,
                                                              views: [savedAmountLabel, remainderLabel])

    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressTintColor = UIColor(hex: ColorConstans.yellow)
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
        containerView.addSubviews(nameBudgetStack, dateProgressStack, savedRemainderStack, resultLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        nameBudgetStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        dateProgressStack.snp.makeConstraints { make in
            make.top.equalTo(nameBudgetStack.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(Constans.smallHeight)
        }
        
        savedRemainderStack.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(savedRemainderStack.snp.bottom).offset(Constans.insetTiny)
            make.leading.equalToSuperview().inset(Constans.insetSmall)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configureCell(finacialGoal: Goal) {
        nameGoalLabel.text = finacialGoal.name
        targetAmountLabel.text = "\(finacialGoal.targetAmount) ₽"
        dateGoalLabel.text = "\(R.string.localizable.dateGoalLabel()) \(finacialGoal.deadline)"
        savedAmountLabel.text = "Внесено: \(finacialGoal.savedAmount)₽"
        remainderLabel.text = "Остаток: \(finacialGoal.targetAmount - finacialGoal.savedAmount)₽"
        let progress = Float(finacialGoal.savedAmount) / Float(finacialGoal.targetAmount)
        progressBar.setProgress(progress, animated: false)
        
        switch finacialGoal.status {
        case .completed:
            resultLabel.isHidden = false
            resultLabel.text = R.string.localizable.positiveResult()
            resultLabel.textColor = .systemGreen
        case .failed:
            resultLabel.isHidden = false
            resultLabel.text = R.string.localizable.negativeResult()
            resultLabel.textColor = .systemRed
        case .inProgress:
            resultLabel.isHidden = true
        }
    }
}

// MARK: reuseIndentifier
extension FinanceGoalsTableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
