//
//  SetupCategoryView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit

class SetupCategoryView: UIView {
    
    private lazy var titleLabel = Label(textLabel:  R.string.localizable.setupCategoryLabel(),
                                        textSize: 24, weight: .medium)
    
    private lazy var categoryLabel = Label(textLabel:  R.string.localizable.categoryLabel(),
                                           textSize: 16, weight: .medium)
    
    private lazy var changeCategoryButton = DefaultButton(title:  R.string.localizable.changeButton(),
                                                          buttonBackgroundColor: .white,
                                                          titleColor: .systemBlue, titleFontSize: 16) { }
    
    private lazy var stackLabel = Stack(stackAxis: .horizontal, stackDistribution: .equalSpacing,
                                        views: [categoryLabel, changeCategoryButton])
    
    private lazy var categoryButton = ListButton(title: "Категория", nameImage: "food_icon")
    private lazy var editColorCategoryLabel = Label(textLabel:  R.string.localizable.changeCategoryColorLabel(),
                                                    textSize: 16, weight: .medium)
    
    private lazy var colorView = ColorView()
    
    private lazy var makeChangesButton = DefaultButton(title: R.string.localizable.makeChangesButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupCategoryColor()
    }
    
    private func setupCategoryColor() {
        colorView.onClickColor = { [weak self] color in
            self?.categoryButton.iconColor = color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubviews(titleLabel, stackLabel, categoryButton, editColorCategoryLabel, colorView, makeChangesButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        stackLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(stackLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        editColorCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        colorView.snp.makeConstraints { make in
            make.top.equalTo(editColorCategoryLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(180)
        }
        
        makeChangesButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
