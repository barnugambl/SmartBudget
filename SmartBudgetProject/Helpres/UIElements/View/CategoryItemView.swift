//
//  CategoryItemView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import UIKit

class CategoryItemView: UIView {
    var category: CategoryDto
    private var completion: ((CategoryDto) -> Void)?
    var sliderValue: (() -> Void)?
    var onPercentageChange: ((String, Int) -> Bool)?
    private let persentage: Int?
    
    private lazy var nameLabel = UILabel.create(text: category.name, fontSize: 16, weight: .regular)
    private lazy var persentLabel = UILabel.create(fontSize: 16)
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.layer.cornerRadius = 5
        slider.backgroundColor = .clear
        slider.minimumTrackTintColor = category.iconColor
        slider.maximumTrackTintColor = .systemGray5.withAlphaComponent(0.9)
        let thumbImage = UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15))
            .withTintColor(category.iconColor, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.addAction(UIAction(handler: { _ in
            self.sliderValueChanged()
        }), for: .valueChanged)
        return slider
    }()
    
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
        slider.value = Float(persentage ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconContainer.layer.cornerRadius = iconContainer.bounds.height / 2
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
    
    private func sliderValueChanged() {
        let newValue = Int(slider.value)
        
        if let canAdjust = onPercentageChange?(category.name, newValue), canAdjust {
            category.persentage = newValue
            updatePersentLabel()
            slider.maximumTrackTintColor = .systemGray5.withAlphaComponent(0.9)
        } else {
            slider.value = Float(category.persentage)
            UIView.animate(withDuration: 0.1, animations: {
                    self.slider.transform = CGAffineTransform(translationX: -3, y: 0)
                },
                completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.slider.transform = .identity
                    }
                }
            )
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        sliderValue?()
    }
    
    func updatePersentLabel() {
        persentLabel.text = "\(category.persentage)%"
    }
    
    func updateColor(_ color: UIColor) {
        iconContainer.backgroundColor = color
    }
    
    func update(with category: CategoryDto) {
        self.category = category
        slider.value = Float(category.persentage)
        updatePersentLabel()
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
            setupSlider()
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
    
    private func setupSlider() {
        addSubview(slider)
        
        nameLabel.snp.remakeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing).offset(20)
            make.top.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(16)
            make.leading.equalTo(iconContainer.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(5)
        }
        
        iconContainer.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
            make.height.width.equalTo(44)
        }
        
        persentLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(iconContainer.snp.centerY)
        }
    }
}
