//
//  NewPasswordView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit
import SnapKit

final class CreateNewPasswordView: UIView {
    var didTapContinue: (() -> Void)?
    
    private lazy var titleLabel = UILabel.create(text: R.string.localizable.newPasswordLabel(), fontSize: FontSizeConstans.title,
                                                 weight: .medium)
    private lazy var descriptionLabel = UILabel.create(text: R.string.localizable.newPasswordDescrLabel(), fontSize: FontSizeConstans.body,
                                                       textColor: .systemGray, numberOfLines: 0)
    private lazy var passwordLabel = UILabel.create(text: R.string.localizable.passwordLabel(), fontSize: FontSizeConstans.subbody,
                                                    weight: .medium)
    private lazy var confirmationPasswordLabel = UILabel.create(text: R.string.localizable.confirmNewPasswordLabel(),
                                                                fontSize: FontSizeConstans.subbody, weight: .medium)
    
    private lazy var passwordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.createNewPasswordTextField(),
                                                          isPassword: true)
    private lazy var confirmationPasswordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable
            .confirmNewPasswordTextField(), isPassword: true)
    
    private lazy var completionButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmationButton())) { [weak self] in
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
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.equalToSuperview().inset(Constans.insetSmall)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constans.insetLarge)
            make.leading.trailing.equalToSuperview().offset(Constans.insetSmall)
        }
       
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constans.insetMedium)
            make.leading.equalTo(passwordTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextField)
        }
        
        confirmationPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constans.insetMedium)
            make.leading.equalTo(passwordTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        confirmationPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmationPasswordLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextField)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(confirmationPasswordTextField.snp.bottom).offset(Constans.insetXXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
        }
    }
    
}
