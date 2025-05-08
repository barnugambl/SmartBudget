//
//  AuthView.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import UIKit
import SnapKit


enum LogViewEvent {
    case didTapRegister
    case didTapForgotPassword
    case didTapLogin
    case didTapTId
}

class LogView: UIView {
    var onEvent: ((LogViewEvent) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var phoneNumberTextField = PhoneNumberTextField()
    
    private lazy var passwordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.inputPasswordTextField(),
                                                   isPassword: true)
    
    private lazy var title = Label(textLabel: R.string.localizable.logLabel(), textSize: 24, weight: .medium)
    private lazy var logButton = DefaultButton(title: R.string.localizable.logButton(),
                                               buttonBackgroundColor: .white,
                                               layerBorderWidth: 1,
                                               layerBorderColor: UIColor.systemGray.cgColor) { [weak self] in
        self?.onEvent?(.didTapLogin)
        
    }
    private lazy var regButton = DefaultButton(title: R.string.localizable.regButton(),
                                               buttonBackgroundColor: .systemGray5) { [weak self] in
        self?.onEvent?(.didTapRegister)
    }
    
    private lazy var tIdButton = DefaultButton(title: R.string.localizable.tIdButtonTitle(),
                                               nameImage: R.image.tid_icon.name) { [weak self] in
        self?.onEvent?(.didTapTId)
    }
    
    private lazy var forgotButtonPassword = DefaultButton(title: R.string.localizable.forgotPasswordButton(),                                                       buttonBackgroundColor: .white,
                                                    titleColor: .systemBlue) { [weak self] in
        self?.onEvent?(.didTapForgotPassword)
    }
    
    private lazy var separatorView = SeparatorView()
    
    private lazy var formFieldStack = Stack(stackSpaicing: 32, views: [phoneNumberTextField, passwordTextField])
    
    private lazy var buttonsStackView = Stack(stackSpaicing: 32, views: [logButton, separatorView, tIdButton,regButton])
    
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubviews(title, formFieldStack, forgotButtonPassword, buttonsStackView)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
        }
        
        formFieldStack.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        formFieldStack.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(48)
        }})
        
        forgotButtonPassword.snp.makeConstraints { make in
            make.top.equalTo(formFieldStack.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(forgotButtonPassword.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        buttonsStackView.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .forEach { button in
                button.snp.makeConstraints { make in
                    make.height.equalTo(48)
            }
        }
    }
}
