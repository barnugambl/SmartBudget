//
//  CategoryItemView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import UIKit

class CategoryItemView: UIView {
    private var category: CategoryDto
    private let completion: ((CategoryDto) -> Void)?
    private let persentage: Int?
    
    private lazy var nameLabel = UILabel.create(text: category.name, fontSize: 16, weight: .regular)
    private lazy var persentLabel = UILabel.create(fontSize: 16)
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var iconContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var shevronIconButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemGray3
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.completion?(self.category)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    init(category: CategoryDto, persentage: Int? = nil, completion: ((CategoryDto) -> Void)?) {
        self.category = category
        self.completion = completion
        self.persentage = persentage
        super.init(frame: .zero)
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
    
    func updateColor(_ color: UIColor) {
        iconContainer.backgroundColor = color
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
        addSubviews(nameLabel)
        setupIconContainerView()
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupIconContainerView() {
        addSubviews(iconContainer)
        iconContainer.addSubview(icon)
        icon.image = UIImage(named: category.iconName)
        iconContainer.backgroundColor = category.iconColor
        
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
        
        if persentage != nil {
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
        persentLabel.text = "\(persentage ?? 0)%"
        persentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
