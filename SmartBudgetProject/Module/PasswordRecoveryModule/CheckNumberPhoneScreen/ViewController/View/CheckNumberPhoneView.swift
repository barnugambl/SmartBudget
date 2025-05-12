//
//  CheckEmailView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit

enum CheckNumberViewEvent {
    case didTapContinue
    case didTapHaventEmail
}

class CheckNumberPhoneView: UIView {
    
    var onEvent: ((CheckNumberViewEvent) -> Void)?
    
    private lazy var title = Label(textLabel: R.string.localizable.checkPhoneLabel(),
                                   textSize: 24, weight: .medium)
    
    private lazy var codeDescription = Label(textLabel: R.string.localizable.checkPhoneDescrLabel(),
        textSize: 16, textColor: .systemGray, numberLines: 0)
    
    private lazy var continueButton = DefaultButton(title: R.string.localizable.continueButton()) { [weak self] in
        self?.onEvent?(.didTapContinue)
    }
    
    private lazy var digitInputView = DigitInputView()
    
    private lazy var haventEmailLabel = Label(textLabel: R.string.localizable.havenCodeLabel(),
                                              textSize: 14, textColor: .systemGray)
    
    private lazy var titleDescrStack = Stack(stackSpaicing: 20, views: [title, codeDescription])
    
    private lazy var resendEmailButton = DefaultButton(title: R.string.localizable.resendCodeButton(),
                                                       buttonBackgroundColor: .white, titleColor: .systemBlue,
                                                       titleFontSize: 14) { [weak self] in
        self?.onEvent?(.didTapHaventEmail)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(titleDescrStack, continueButton, digitInputView, haventEmailLabel, resendEmailButton)
        titleDescrStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        digitInputView.snp.makeConstraints { make in
            make.top.equalTo(titleDescrStack.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(digitInputView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        haventEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        resendEmailButton.snp.makeConstraints { make in
            make.top.equalTo(haventEmailLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
