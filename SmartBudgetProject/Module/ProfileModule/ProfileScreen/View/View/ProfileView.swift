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
    case didTapEditProfile
}

class ProfileView: UIView {
    var onEvent: ((ProfileViewEvent) -> Void)?
    
    lazy var titleLabel = Label(textLabel: "Личный кабинет", textSize: 24, weight: .medium)
    private lazy var nameLabel = Label(textLabel: "Ivan ivanov", textSize: 16, textColor: .systemGray2)

    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 75 / 2
        image.clipsToBounds = true
        image.contentMode = .center
        image.image = UIImage(resource: .cameraIcon)
        image.backgroundColor = .systemGray4
        return image
    }()
        
    private lazy var financesButton = ItemView(title: R.string.localizable.myFinancesButton(),
                                               iconName: R.image.finance_icon.name) { [weak self] in
        self?.onEvent?(.didTapFinanses)
    }
    
    private lazy var expensehistoryButton = ItemView(title: R.string.localizable.expensehistoryButton(),
                                                     iconName: R.image.expensehistory_icon.name) { [weak self] in
            self?.onEvent?(.didTapExpenseHistory)
    }
    
    private lazy var editProfileButton = ItemView(title: R.string.localizable.editProfileButton(),
                                                    iconName: R.image.edit_icon.name) { [weak self] in
        self?.onEvent?(.didTapEditProfile)
    }
    
    private lazy var darkThemeButton = ItemView(title: R.string.localizable.darkThemeButton(),
                                                  iconName: R.image.moon_icon.name)
    
    private lazy var editLanguageButton = ItemView(title: R.string.localizable.editLanguageButton(),
                                                     iconName: R.image.language_icon.name)
    
    private lazy var buttonStack = Stack(stackSpaicing: 30, views: [financesButton, expensehistoryButton, editProfileButton, darkThemeButton,
                                                                    editLanguageButton])
    private lazy var avatarNameStack = Stack(stackSpaicing: 10, stackAligment: .center, views: [avatarImage, nameLabel])

    private lazy var darkThemeSwitch: UISwitch = {
        let swt = UISwitch()
        swt.preferredStyle = .sliding
        return swt
    }()
    
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
        addSubviews(avatarNameStack, buttonStack)
        darkThemeButton.addSubview(darkThemeSwitch)
        
        avatarNameStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.trailing.leading.equalToSuperview().inset(16)
        }
        
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(avatarNameStack.snp.bottom).offset(40)
            make.trailing.leading.equalToSuperview().inset(16)
        }
        
        buttonStack.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(60)
        }})
        
        darkThemeSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
