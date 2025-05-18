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

final class LogView: UIView {
    var onEvent: ((LogViewEvent) -> Void)?
    
    private lazy var title = UILabel.create(text: R.string.localizable.logLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    
    private lazy var phoneNumberTextField = PhoneNumberTextField()
    private lazy var passwordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.inputPasswordTextField(),
                                                          isPassword: true)
    
    private lazy var logButton = UIButton.create(style: .white(title: R.string.localizable.logButton())) { [weak self] in
        self?.onEvent?(.didTapLogin)
    }
    
    private lazy var regButton = UIButton.create(style: .gray(title: R.string.localizable.regButton())) { [weak self] in
        self?.onEvent?(.didTapRegister)
    }
    
    private lazy var tIdButton = UIButton.create(style: .yellow(title: R.string.localizable.tIdButtonTitle(),
                                                                imageName: R.image.tid_icon.name)) { [weak self] in
        self?.onEvent?(.didTapTId)
    }
    
    private lazy var forgotButtonPassword = UIButton.create(style: .blue(title: R.string.localizable.forgotPasswordButton())) { [weak self] in
        self?.onEvent?(.didTapForgotPassword)
    }
    
    private lazy var separatorView = SeparatorView()
    
    private lazy var formFieldStackView = UIStackView.create(stackSpacing: Constans.largeStackSpacing,
                                                             views: [phoneNumberTextField, passwordTextField])
    private lazy var buttonsStackView = UIStackView.create(stackSpacing: Constans.largeStackSpacing,
                                                           views: [logButton, separatorView, tIdButton, regButton])
    
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
        addSubviews(title, formFieldStackView, forgotButtonPassword, buttonsStackView)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetTiny)
            make.centerX.equalToSuperview()
        }
        
        formFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Constans.insetXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        formFieldStackView.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(Constans.heightButton)
        }})
        
        forgotButtonPassword.snp.makeConstraints { make in
            make.top.equalTo(formFieldStackView.snp.bottom).offset(Constans.insetTiny)
            make.leading.equalTo(formFieldStackView.snp.leading).inset(Constans.textFieldContentInset)
            make.height.equalTo(Constans.heightButton / 2)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(forgotButtonPassword.snp.bottom).offset(Constans.insetLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        buttonsStackView.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .forEach { button in
                button.snp.makeConstraints { make in
                    make.height.equalTo(Constans.heightButton)
            }
        }
    }
}
