//
//  ListButton.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 21.04.2025.
//

import UIKit
import SnapKit

class ListButton: UIButton {
    private var title: String
    private var buttonBackgroundColor: UIColor
    private var titleColor: UIColor
    private var completion: (() -> Void)?
    private var nameImage: String
    private var isMenu: Bool
    var iconColor: UIColor {
        didSet {
            iconContainer.backgroundColor = iconColor
        }
    }
    
    private let iconContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let shevronIconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var chevronIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.down")
        return image
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    init(title: String,
         buttonBackgroundColor: UIColor = .systemBackground,
         titleColor: UIColor = .black,
         nameImage: String,
         iconColor: UIColor = .systemBlue,
         isMenu: Bool = false,
         completion: (() -> Void)? = nil,
         frame: CGRect = .zero) {
        
        self.title = title
        self.buttonBackgroundColor = buttonBackgroundColor
        self.titleColor = titleColor
        self.nameImage = nameImage
        self.completion = completion
        self.isMenu = isMenu
        self.iconColor = iconColor
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        addAction(UIAction(handler: { [weak self] _ in
            self?.completion?()
        }), for: .touchUpInside)
        
        setupShadow()
        setupAppearance()
        setupContainerView()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupAppearance() {
        backgroundColor = buttonBackgroundColor
        layer.cornerRadius = 20
        clipsToBounds = false
        contentHorizontalAlignment = .leading
        

        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 0)
        
        var titleAttr = AttributedString(title)
        titleAttr.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleAttr.foregroundColor = titleColor
        config.attributedTitle = titleAttr
        
        self.configuration = config
       
    }
    
    private func setupContainerView() {
        addSubview(iconContainer)
        iconContainer.addSubview(icon)
        iconContainer.backgroundColor = iconColor
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        icon.image = UIImage(named: nameImage)
        
        if isMenu {
            lazy var button: UIButton = {
                let button = UIButton(type: .system)
                button.setImage(chevronIcon.image, for: .normal)
                return button
            }()
            
            lazy var ruAction = UIAction(title: "Русский", state: .on) { _ in
                print("ru")
            }
            
            lazy var enAction = UIAction(title: "Английский") { _ in
                print("ru")
            }
            
            lazy var languageMenu = UIMenu(title: "Выберите язык", children: [ruAction, enAction])
            
            button.menu = languageMenu
            button.showsMenuAsPrimaryAction = true
            
            addSubview(button)
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.trailing.equalToSuperview().inset(20)
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconContainer.layer.cornerRadius = iconContainer.bounds.height / 2
    }
}
