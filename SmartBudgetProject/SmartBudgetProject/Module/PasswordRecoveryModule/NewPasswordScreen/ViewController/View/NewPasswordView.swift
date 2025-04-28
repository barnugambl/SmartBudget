//
//  NewPasswordView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit
import SnapKit

class NewPasswordView: UIView {
    
    var didTapContinue: (() -> Void)?
    
    private lazy var title = Label(textLabel: R.string.localizable.newPasswordLabel(), textSize: 24)
    
    private lazy var descr = Label(textLabel: R.string.localizable.newPasswordDescrLabel(),
                                   textSize: 16, textColor: .systemGray, numberLines: 0)
    
    private lazy var passwordLabel = Label(textLabel: R.string.localizable.passwordLabel(), textSize: 14)
    
    private lazy var confirmationPasswordLabel = Label(
        textLabel: R.string.localizable.confirmNewPasswordLabel(),
        textSize: 14)
    
    private lazy var passwordTextField = TextField(
        fieldPlaceHodler: R.string.localizable.createNewPasswordTextField(),
        isPassword: true)
    
    private lazy var confirmationPasswordTextField = TextField(
        fieldPlaceHodler: R.string.localizable.confirmNewPasswordTextField(), isPassword: true)
    
    private lazy var completionButton = DefaultButton(
        title: R.string.localizable.confirmationButton()) { [weak self] in
            self?.didTapContinue?()
    }
    
    private lazy var passwordStack = Stack(stackSpaicing: 5, views: [passwordLabel, passwordTextField])
    
    private lazy var confiramtionPasswordStack = Stack(stackSpaicing: 5,
                                            views: [confirmationPasswordLabel, confirmationPasswordTextField])

    private lazy var mainStack = Stack(stackSpaicing: 20, views: [passwordStack, confiramtionPasswordStack])
    
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
        addSubviews(title, descr, mainStack, completionButton)
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        descr.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(16)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(descr.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        confirmationPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(mainStack.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
}
