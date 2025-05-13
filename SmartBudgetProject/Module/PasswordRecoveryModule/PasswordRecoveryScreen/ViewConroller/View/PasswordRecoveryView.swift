//
//  PasswordRecoveryView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit
import SnapKit

class PasswordRecoveryView: UIView {
    
    var completion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var title = Label(textLabel: R.string.localizable.forgotPasswordLabel(), textSize: 24,
                                   weight: .medium)
    
    private lazy var passwordResDescrLabel = Label(
        textLabel: R.string.localizable.forgotPasswordDescrLabel(),
        textSize: 16, textColor: .systemGray)
    
    private lazy var phoneNumberInputLabel = Label(textLabel: R.string.localizable.numberPhoneLabel(),
                                                   textSize: 14, weight: .medium)
    
    private lazy var phoneNumberTextField = PhoneNumberTextField()
    
    private lazy var continueButton = DefaultButton(
        title: R.string.localizable.continueButton()) { [weak self] in
        guard let self else { return }
        self.completion?()
    }
    private lazy var titleAndDescrStack = Stack(stackSpaicing: 32, views: [title, passwordResDescrLabel])
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        addSubviews(titleAndDescrStack,  phoneNumberInputLabel, phoneNumberTextField, continueButton)
        titleAndDescrStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneNumberInputLabel.snp.makeConstraints { make in
            make.top.equalTo(titleAndDescrStack.snp.bottom).offset(32)
            make.leading.equalTo(phoneNumberTextField.snp.leading).offset(10)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberInputLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)

        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
