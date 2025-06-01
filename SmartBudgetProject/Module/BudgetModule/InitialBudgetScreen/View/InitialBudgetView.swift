//
//  InitialBudgetView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit

final class InitialBudgetView: UIView {
    var categories: [CategoryDto]
    var categoryViews: [CategoryItemView] = []

    var clickOnConfirmButton: (([CategoryDto]) -> Void)?
    var clickOnCategory: ((CategoryDto) -> Void)?

    private lazy var scroll = UIScrollView.create()
    
    private lazy var contentView = UIView()
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.distributeBudgetLabel(), fontSize: FontSizeConstans.title,
                                         weight: .medium)
    private lazy var inputSumLabel = UILabel.create(text: R.string.localizable.inputBudgetLabel(), fontSize: FontSizeConstans.body,
                                                    weight: .medium)
    private lazy var setupCategoriesLabel = UILabel.create(text: R.string.localizable.setupCategoryLabel(), fontSize: FontSizeConstans.body,
                                                           weight: .medium)
    private lazy var errorLabel = UILabel.create(fontSize: FontSizeConstans.caption, weight: .medium, textColor: .red)
    
    lazy var amountTextField = AmountTextField()
    
    private lazy var categoryStack = UIStackView.create(stackSpacing: Constans.mediumStackSpacing)
    
    private lazy var confirmButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmationButton())) { [weak self] in
        guard let self else { return }
        self.clickOnConfirmButton?(categories)
    }
    
    init(categories: [CategoryDto]) {
        self.categories = categories
        super.init(frame: .zero)
        setupView()
        setupCategoryViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCategoryViews() {
        categories.forEach { category in
            let view = CategoryItemView(category: category) { [weak self] _ in
                self?.clickOnCategory?(category)
            }
            categoryViews.append(view)
            categoryStack.addArrangedSubview(view)
        }
    }
    
    func setErrorMessage(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        errorLabel.isHidden = true
        addSubview(scroll)
        scroll.addSubview(contentView)
        contentView.addSubviews(inputSumLabel, amountTextField, errorLabel, setupCategoriesLabel, categoryStack, confirmButton)
        
        scroll.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        inputSumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constans.insetLarge)
            make.leading.equalTo(amountTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(inputSumLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButtonMedium)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(5)
            make.leading.equalTo(amountTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        setupCategoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(Constans.insetXLarge)
            make.leading.equalTo(categoryStack.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        categoryStack.snp.makeConstraints { make in
            make.top.equalTo(setupCategoriesLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        categoryStack.arrangedSubviews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(Constans.heightButtonMedium)
            }
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(categoryStack.snp.bottom).offset(Constans.insetXLarge)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButton)
            make.bottom.equalToSuperview().offset(InitialBudgetView.confrimButtonInsetBottom)
        }
    }
}

// MARK: Constans
extension InitialBudgetView {
    static let confrimButtonInsetBottom: CGFloat = -20
}
