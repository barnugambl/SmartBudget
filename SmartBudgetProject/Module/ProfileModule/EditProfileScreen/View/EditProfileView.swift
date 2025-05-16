//
//  EditProfileView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit
import SnapKit

final class EditProfileView: UIView {
    lazy var titleLabel = UILabel.create(text: R.string.localizable.editProfileLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var editNumberLabel = UILabel.create(text: R.string.localizable.editNumberPhoneLabel(), fontSize: FontSizeConstans.body)
    private lazy var editPasswordLabel = UILabel.create(text: R.string.localizable.editPasswordLabel(), fontSize: FontSizeConstans.body)
    private lazy var confirmPasswordLabel = UILabel.create(text: R.string.localizable.confirmNewPasswordLabel(), fontSize: FontSizeConstans.body)

    private lazy var editNumberTextField = DefaultTextField(fieldPlaceHodler: "+7-XXX-XXX-XX-XX")
    private lazy var editPasswordTextField = DefaultTextField(fieldPlaceHodler: "****", isPassword: true)
    private lazy var confirmPasswordTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.confirmNewPasswordTextField())
        
    private lazy var confirmButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmationButton())) { }
    
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
        addSubviews(editNumberLabel, editNumberTextField, editPasswordLabel, editPasswordTextField,
                    confirmPasswordLabel, confirmPasswordTextField, confirmButton)
            
        editNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.equalTo(editNumberTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
            
        editNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(editNumberLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextField)
        }
        
        editPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(editNumberTextField.snp.bottom).offset(Constans.insetXLarge)
            make.leading.equalTo(editPasswordTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
         
        editPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(editPasswordLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextField)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(editPasswordTextField.snp.bottom).offset(Constans.insetXLarge)
            make.leading.equalTo(confirmPasswordTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextField)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
        }
    }
}
