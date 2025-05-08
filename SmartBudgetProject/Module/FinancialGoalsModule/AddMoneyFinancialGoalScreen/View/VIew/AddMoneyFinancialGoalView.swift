//
//  AddMoneyFinancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit

class AddMoneyFinancialGoalView: UIView {
                
    lazy var titleLabel = Label(textSize: 24, weight: .medium)
    
    private lazy var addAmountLabel = Label(textLabel: "Введите сумму",textSize: 16, weight: .medium)
        
    private lazy var addAmountTextField = AmountTextField()
    private lazy var amountStack = Stack(stackSpaicing: 8, views: [addAmountLabel, addAmountTextField])
    private lazy var confirmationButton = DefaultButton(title: "Внести сумму")
    
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
    
    private func setupLayout() {
        addSubviews(titleLabel, amountStack, confirmationButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
        
        amountStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addAmountTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        
        confirmationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}
