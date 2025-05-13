//
//  NewPasswordView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit
import SnapKit

class CreateNewPasswordView: UIView {
    
    var didTapContinue: (() -> Void)?
    
    private lazy var titleLabel = Label(textLabel: R.string.localizable.newPasswordLabel(), textSize: 24, weight: .medium)
    
    private lazy var descriptionLabel = Label(textLabel: R.string.localizable.newPasswordDescrLabel(), textSize: 16,
                                              textColor: .systemGray, numberLines: 0)
    
    private lazy var passwordLabel = Label(textLabel: R.string.localizable.passwordLabel(), textSize: 14, weight: .medium)
    
    private lazy var confirmationPasswordLabel = Label(textLabel: R.string.localizable.confirmNewPasswordLabel(),
                                                       textSize: 14, weight: .medium)
    
    private lazy var passwordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.createNewPasswordTextField(),
                                                          isPassword: true)
    
    private lazy var confirmationPasswordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.confirmNewPasswordTextField(),                                                                    isPassword: true)
    
    private lazy var completionButton = DefaultButton(title: R.string.localizable.confirmationButton()) { [weak self] in
            self?.didTapContinue?()
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
        backgroundColor = .white
    }
    
    private func setupLayout() {
        addSubviews(titleLabel, descriptionLabel, passwordLabel, passwordTextField,
                    confirmationPasswordLabel, confirmationPasswordTextField, completionButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().offset(16)
        }
       
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(passwordTextField.snp.leading).inset(10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        confirmationPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(passwordTextField.snp.leading).inset(10)
        }
        
        confirmationPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmationPasswordLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(confirmationPasswordTextField.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
}
