//
//  EditProfileView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit
import SnapKit

class EditProfileView: UIView {
    
    private lazy var titleLabel = Label(textLabel: R.string.localizable.editProfileLabel(),
                                        textSize: 20, weight: .medium)
    
    private lazy var editNumberLabel = Label(textLabel: R.string.localizable.editNumberPhoneLabel(),
                                             textSize: 16)
    
    private lazy var editNumberTextField = DefaultTextField(fieldPlaceHodler: "+7-XXX-XXX-XX-XX")
    
    private lazy var editPasswordLabel = Label(textLabel: R.string.localizable.editPasswordLabel(),
                                               textSize: 16)
    
    private lazy var editPasswordTextField = DefaultTextField(fieldPlaceHodler: "****",
                                                       isPassword: true)
    
    private lazy var confirmPasswordLabel = Label(textLabel: R.string.localizable.confirmNewPasswordLabel(),
                                                  textSize: 16)
    
    private lazy var confirmPasswordTextField = DefaultTextField(
        fieldPlaceHodler: R.string.localizable.confirmNewPasswordTextField())
    
    private lazy var numberStack = Stack(stackSpaicing: 8, views: [editNumberLabel, editNumberTextField])
    
    private lazy var passwordStack = Stack(stackSpaicing: 8, views: [editPasswordLabel, editPasswordTextField])
    
    private lazy var confirmPasswordStack = Stack(stackSpaicing: 8,
                                                  views: [confirmPasswordLabel, confirmPasswordTextField])
    
    private lazy var confirmButton = DefaultButton(title: R.string.localizable.confirmationButton()) { }
    
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
        addSubviews(titleLabel, numberStack, passwordStack, confirmPasswordStack, confirmButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        numberStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordStack.snp.makeConstraints { make in
            make.top.equalTo(numberStack.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        confirmPasswordStack.snp.makeConstraints { make in
            make.top.equalTo(passwordStack.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        [editNumberTextField, editPasswordTextField, confirmPasswordTextField]
            .forEach({ $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            } })
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
}
