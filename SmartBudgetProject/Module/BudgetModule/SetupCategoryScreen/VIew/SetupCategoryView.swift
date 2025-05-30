//
//  SetupCategoryView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit

final class SetupCategoryView: UIView {
    var clickOnchangeButton: (() -> Void)?
    var clickOnConfirmButton: ((UIColor, String) -> Void)?
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.setupCategoryLabel(), fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var categoryLabel = UILabel.create(text: R.string.localizable.categoryLabel(), fontSize: FontSizeConstans.body, weight: .medium)
    private lazy var editColorCategoryLabel = UILabel.create(text: R.string.localizable.changeCategoryColorLabel(),
                                                             fontSize: FontSizeConstans.body, weight: .medium)
    
    private lazy var stackLabel = UIStackView.create(stackAxis: .horizontal, stackDistribution: .equalSpacing,
                                                          views: [categoryLabel, changeCategoryButton])
    
    private lazy var categoryView = ItemView(title: "Категория", iconName: "food_icon", iconColor: .black)
    
    private lazy var colorView = ColorView()
    
    private lazy var makeChangesButton = UIButton.create(style: .yellow(title: R.string.localizable.makeChangesButton())) { [weak self] in
        guard let color = self?.categoryView.iconColor, let name = self?.categoryView.title else { return }
        self?.clickOnConfirmButton?(color, name)
    }
    private lazy var changeCategoryButton = UIButton.create(style: .blue(title: R.string.localizable.changeButton())) { [weak self] in
        self?.clickOnchangeButton?()
    }
                                                          
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupCategoryColor()
    }
    
    private func setupCategoryColor() {
        colorView.onClickColor = { [weak self] color in
            self?.categoryView.iconColor = color
        }
    }
    
    func setupCategoryView(category: CategoryDto) {
        categoryView.title = category.name
        categoryView.iconName = category.iconName
        categoryView.iconColor = category.iconColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubviews(stackLabel, categoryView, editColorCategoryLabel, colorView, makeChangesButton)
    
        stackLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(stackLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightItemView)
        }
        
        editColorCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(Constans.insetLarge)
            make.leading.equalTo(colorView.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        colorView.snp.makeConstraints { make in
            make.top.equalTo(editColorCategoryLabel.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(SetupCategoryView.heightColorView)
        }
        
        makeChangesButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightButton)
        }
    }
}

// MARK: Constant
extension SetupCategoryView {
    static let heightColorView: CGFloat = 180
}
