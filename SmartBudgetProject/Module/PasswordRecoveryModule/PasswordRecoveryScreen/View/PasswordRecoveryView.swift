//
//  PasswordRecoveryView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit
import SnapKit

final class PasswordRecoveryView: UIView {
    var completion: (() -> Void)?
    
    private lazy var title = UILabel.create(text: R.string.localizable.forgotPasswordLabel(), fontSize: FontSizeConstans.title,
                                            weight: .medium)
    private lazy var passwordResDescrLabel = UILabel.create(text: R.string.localizable.forgotPasswordDescrLabel(),
                                                            fontSize: FontSizeConstans.body, textColor: .systemGray)
    private lazy var phoneNumberInputLabel = UILabel.create(text: R.string.localizable.numberPhoneLabel(), fontSize: FontSizeConstans.subbody,
                                                            weight: .medium)
    
    private lazy var phoneNumberTextField = PhoneNumberTextField()

    private lazy var continueButton = UIButton.create(style: .yellow(title: R.string.localizable.continueButton())) { [weak self] in
        self?.completion?()
    }
    
    private lazy var titleAndDescrStack = UIStackView.create(stackSpacing: Constans.largeStackSpacing, views: [title, passwordResDescrLabel])
   
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
        addSubviews(titleAndDescrStack, phoneNumberInputLabel, phoneNumberTextField, continueButton)
        titleAndDescrStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        phoneNumberInputLabel.snp.makeConstraints { make in
            make.top.equalTo(titleAndDescrStack.snp.bottom).offset(Constans.insetLarge)
            make.leading.equalTo(phoneNumberTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberInputLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightTextField)

        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(Constans.insetXXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
        }
    }
}
