//
//  ItemView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 03.05.2025.
//

import UIKit

final class ItemView: UIView {
    var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    
    var iconName: String {
        didSet {
            icon.image = UIImage(named: iconName)
        }
    }
    
    var iconColor: UIColor {
        didSet {
            iconContainer.backgroundColor = iconColor
        }
    }
    
    private var isPersent: Bool
    
    private let completion: (() -> Void)?
    
    private lazy var titleLabel = UILabel.create(text: title, fontSize: 16, weight: .regular)
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var shevronIconButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemGray3
        let action = UIAction { [weak self] _ in
            self?.completion?()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var persentLabel = UILabel.create(fontSize: 16)
    
    init(title: String, iconName: String, iconColor: UIColor = .systemBlue, isPersent: Bool = false,
         completion: (() -> Void)? = nil, frame: CGRect = .zero) {
        self.title = title
        self.iconName = iconName
        self.iconColor = iconColor
        self.isPersent = isPersent
        self.completion = completion
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconContainer.layer.cornerRadius = iconContainer.bounds.height / 2
    }
    
    func setPersent(_ persent: Int) {
        persentLabel.text = "\(persent)%"
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.shadowColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.cornerRadius = 20
        clipsToBounds = false
    }
    
    private func setupLayout() {
        addSubviews(titleLabel)
        setupIconContainerView()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupIconContainerView() {
        addSubviews(iconContainer)
        iconContainer.addSubview(icon)
        icon.image = UIImage(named: iconName)
        iconContainer.backgroundColor = iconColor
        
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.center.equalToSuperview()
        }
        
        if completion != nil {
            setupShevronIconButton()
        }
        
        if isPersent {
            setupPersentLabel()
        }
    }
    
    private func setupShevronIconButton() {
        addSubviews(shevronIconButton)
        shevronIconButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(22)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupPersentLabel() {
        addSubview(persentLabel)
        persentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
