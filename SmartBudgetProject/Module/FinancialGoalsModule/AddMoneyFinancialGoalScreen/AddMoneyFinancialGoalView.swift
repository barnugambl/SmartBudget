//
//  AddMoneyFinancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit

final class AddMoneyFinancialGoalView: UIView {
    lazy var titleLabel = UILabel.create(fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var addAmountLabel = UILabel.create(text: R.string.localizable.addAmountLabel(), fontSize: FontSizeConstans.body, weight: .medium)
        
    private lazy var addAmountTextField = AmountTextField()
    
    private lazy var confirmationButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmAmountButton())) { }
    
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
        addSubviews(addAmountLabel, addAmountTextField, confirmationButton)
        
        addAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(Constans.insetMedium)
            make.leading.equalTo(addAmountTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        addAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(addAmountLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextFieldMedium)
        }
        
        confirmationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Constans.insetMedium)
        }
    }
}
