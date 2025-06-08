//
//  AddMoneyFinancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit

final class AddMoneyFinancialGoalView: UIView {
    var clickOnConfirmButton: (() -> Void)?
    
    lazy var titleLabel = UILabel.create(fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var errorLabel = UILabel.create(fontSize: FontSizeConstans.caption, weight: .medium, textColor: .systemRed)
    private lazy var addAmountLabel = UILabel.create(text: R.string.localizable.addAmountLabel(), fontSize: FontSizeConstans.body, weight: .medium)
        
    lazy var addAmountTextField = AmountTextField()
    
    private lazy var confirmationButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmAmountButton())) { [weak self] in
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
    
    func setErrorMessage(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func setupLayout() {
        errorLabel.isHidden = true
        addSubviews(addAmountLabel, addAmountTextField, errorLabel, confirmationButton)
        
        addAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(Constans.insetMedium)
            make.leading.equalTo(addAmountTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        addAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(addAmountLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextFieldMedium)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(addAmountTextField.snp.bottom).offset(Constans.insetTiny)
            make.leading.equalTo(addAmountTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        confirmationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Constans.insetMedium)
        }
    }
}
