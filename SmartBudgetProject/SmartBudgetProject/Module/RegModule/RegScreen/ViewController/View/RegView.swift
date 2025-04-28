//
//  RegView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 14.04.2025.
//

import UIKit
import SnapKit

enum RegViewEvent {
    case didTapSendCode
    case didTapTId
    case didTapLogin
}

class RegView: UIView {
    var onEvent: ((RegViewEvent) -> Void)?
    
    private lazy var titleLabel = Label(textLabel: R.string.localizable.regLabel(),
                                        textSize: 24, weight: .medium)
    
    private lazy var phoneNumberTextField = TextField(
        fieldPlaceHodler: R.string.localizable.inputNumberTextField(),
        keyType: .numberPad)
    
    private lazy var sendCodeButton = DefaultButton(title: R.string.localizable.sendCodeButton(),
                                             buttonBackgroundColor: .white,
                                             layerBorderWidth: 1,
                                             layerBorderColor: UIColor.systemGray.cgColor) { [weak self] in
        self?.onEvent?(.didTapSendCode)
    }
    
    private lazy var separatorView = SeparatorView()
    
    private lazy var tIdButton = DefaultButton(title: R.string.localizable.tIdButtonTitle(),
                                               nameImage: R.image.tid_icon.name) { [weak self] in
        self?.onEvent?(.didTapTId)
    }
    
    private lazy var logButton = DefaultButton(title: R.string.localizable.logButtonTitle(),
                                               buttonBackgroundColor: .systemGray5) { [weak self] in
        self?.onEvent?(.didTapLogin)
    }
    
    private lazy var stackView = Stack(stackSpaicing: 40, views: [phoneNumberTextField, sendCodeButton, separatorView, tIdButton, logButton])
    
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
        addSubviews(titleLabel, stackView)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        [phoneNumberTextField, sendCodeButton, tIdButton, logButton].forEach({
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
        }})
    }
}
