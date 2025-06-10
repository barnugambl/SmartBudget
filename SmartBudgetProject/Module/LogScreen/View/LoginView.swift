//
//  AuthView.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    var didTapLogin: (() -> Void)?
    
    private lazy var title = UILabel.create(text: R.string.localizable.logLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var errorLabel = UILabel.create(fontSize: FontSizeConstans.caption, weight: .medium, textColor: .systemRed)
    
    lazy var phoneNumberTextField = PhoneNumberTextField()
    lazy var passwordTextField = DefaultTextField(
        fieldPlaceHodler: R.string.localizable.inputPasswordTextField(),
        isPassword: true
    )
    
    private lazy var logButton = UIButton.create(style: .yellow(title: R.string.localizable.logButton())) { [weak self] in
        self?.didTapLogin?()
    }
    
    private lazy var formFieldStackView = UIStackView.create(stackSpacing: Constans.largeStackSpacing,
                                                             views: [phoneNumberTextField, passwordTextField])
    
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
        addSubviews(title, formFieldStackView, logButton)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetTiny)
            make.centerX.equalToSuperview()
        }
        
        formFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Constans.insetXXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        formFieldStackView.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(Constans.heightButton)
        }})
        
        logButton.snp.makeConstraints { make in
            make.top.equalTo(formFieldStackView.snp.bottom).offset(Constans.insetXXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
        }
    }
    
    func hideErrorLabel() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
    
    func setTextLabelError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func updateErrorLabelPosition(for textField: UITextField) {
        addSubviews(errorLabel)
        errorLabel.snp.remakeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(Constans.insetTiny)
            make.leading.equalTo(textField.snp.leading).offset(Constans.textFieldContentInset)
        }
    }
}
