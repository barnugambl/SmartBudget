//
//  ProfileView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 21.04.2025.
//

import UIKit

enum ProfileViewEvent {
    case didTapFinanses
    case didTapExpenseHistory
    case didToggleDarkTheme(isOn: Bool)
}

final class ProfileView: UIView {
    var onEvent: ((ProfileViewEvent) -> Void)?
    
    lazy var titleLabel = UILabel.create(text: "Личный кабинет", fontSize: FontSizeConstans.title, weight: .medium)
        
    private lazy var financesButton = ItemView(title: R.string.localizable.myFinancesButton(),
                                               iconName: R.image.finance_icon.name) { [weak self] in
        self?.onEvent?(.didTapFinanses)
    }
    
    lazy var editLanguageItemView = EditLanguageItemView()
    
    private lazy var expensehistoryButton = ItemView(title: R.string.localizable.expensehistoryButton(),
                                                     iconName: R.image.expensehistory_icon.name) { [weak self] in
            self?.onEvent?(.didTapExpenseHistory)
    }
        
    private lazy var darkThemeButton = ItemView(title: R.string.localizable.darkThemeButton(),
                                                iconName: R.image.moon_icon.name)

    private lazy var buttonStack = UIStackView.create(stackSpacing: Constans.largeStackSpacing,
    views: [financesButton, expensehistoryButton, darkThemeButton])
    
    private lazy var darkThemeSwitch: UISwitch = {
        let swt = UISwitch()
        swt.preferredStyle = .sliding
        swt.addTarget(self, action: #selector(darkThemeSwitchChanged), for: .valueChanged)
        swt.isOn = UserDefaultsService.shared.isDarkTheme
        return swt
    }()

    @objc private func darkThemeSwitchChanged(_ sender: UISwitch) {
        onEvent?(.didToggleDarkTheme(isOn: sender.isOn))
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
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubviews(buttonStack, editLanguageItemView)

        buttonStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetXLarge)
            $0.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }

        buttonStack.arrangedSubviews.forEach {
            $0.snp.makeConstraints { $0.height.equalTo(ProfileView.heightItemView) }
        }

        editLanguageItemView.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }

        darkThemeButton.addSubview(darkThemeSwitch)
        darkThemeSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
    }

}

// MARK: Constans
extension ProfileView {
    static let sizeAvatar: CGFloat = 75
    static let heightItemView: CGFloat = 60
}
