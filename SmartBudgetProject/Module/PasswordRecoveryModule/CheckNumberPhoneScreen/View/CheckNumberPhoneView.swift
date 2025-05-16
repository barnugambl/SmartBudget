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

final class CheckNumberPhoneView: UIView {
    var onEvent: ((CheckNumberViewEvent) -> Void)?
    
    private lazy var title = UILabel.create(text: R.string.localizable.checkPhoneLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var codeDescription = UILabel.create(text: R.string.localizable.checkPhoneDescrLabel(), fontSize: FontSizeConstans.body,
                                                      textColor: .systemGray, numberOfLines: CheckNumberPhoneView.codeDescrNumberOfLines)
    private lazy var haventEmailLabel = UILabel.create(text: R.string.localizable.havenCodeLabel(),
                                                       fontSize: FontSizeConstans.subbody, textColor: .systemGray)

    private lazy var continueButton = UIButton.create(style: .yellow(title: R.string.localizable.continueButton())) { [weak self] in
        self?.onEvent?(.didTapContinue)
    }
    
    private lazy var resendEmailButton = UIButton.create(style: .blue(title: R.string.localizable.resendCodeButton())) { [weak self] in
        self?.onEvent?(.didTapHaventEmail)
    }
    
    private lazy var digitInputView = DigitInputView()
    
    private lazy var titleDescrStack = UIStackView.create(stackSpacing: Constans.mediumStackSpacing, views: [title, codeDescription])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupResendEmailButton()
    }
    
    private func setupView() {
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupResendEmailButton() {
        resendEmailButton.titleLabel?.font = UIFont.systemFont(ofSize: FontSizeConstans.subbody)
    }
    
    private func setupLayout() {
        addSubviews(titleDescrStack, continueButton, digitInputView, haventEmailLabel, resendEmailButton)
        titleDescrStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.mediumStackSpacing)
        }
        
        digitInputView.snp.makeConstraints { make in
            make.top.equalTo(titleDescrStack.snp.bottom).offset(Constans.insetLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.mediumStackSpacing)
            make.height.equalTo(Constans.heightTextField)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(digitInputView.snp.bottom).offset(Constans.insetXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
        }
        
        haventEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(Constans.insetLarge)
            make.centerX.equalToSuperview()
        }
        
        resendEmailButton.snp.makeConstraints { make in
            make.top.equalTo(haventEmailLabel.snp.bottom).offset(Constans.insetTiny)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: Constant
extension CheckNumberPhoneView {
    static let codeDescrNumberOfLines = 0
}
