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

final class RegView: UIView {
    var onEvent: ((RegViewEvent) -> Void)?
    
    private lazy var titleLabel = UILabel.create(text: R.string.localizable.regLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    
    private lazy var phoneNumberTextField = PhoneNumberTextField()

    private lazy var separatorView = SeparatorView()
    
    private lazy var sendCodeButton = UIButton.create(style: .white(title: R.string.localizable.sendCodeButton())) { [weak self] in
        self?.onEvent?(.didTapSendCode)
    }
    
    private lazy var tIdButton = UIButton.create(style: .yellow(title: R.string.localizable.tIdButtonTitle(),
                                                                imageName: R.image.tid_icon.name)) { [weak self] in
        self?.onEvent?(.didTapTId)
    }
    
    private lazy var logButton = UIButton.create(style: .gray(title: R.string.localizable.logButtonTitle())) { [weak self] in
        self?.onEvent?(.didTapLogin)
    }
    
    private lazy var stackView = UIStackView.create(stackSpacing: RegView.stackSpacing,
                                                         views: [phoneNumberTextField, sendCodeButton, separatorView, tIdButton, logButton])
    
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
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetTiny)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(RegView.topInset)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        [phoneNumberTextField, sendCodeButton, tIdButton, logButton].forEach({
            $0.snp.makeConstraints { make in
                make.height.equalTo(Constans.heightButton)
        }})
    }
}

// MARK: Constans
extension RegView {
    static let stackSpacing: CGFloat = 40
    static let topInset: CGFloat = 60
}
