//
//  InitialBudgetView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit

final class InitialBudgetView: UIView {
    var clickOnConfirmButton: (() -> Void)?
    var clickOnCategory: ((String, String, UIColor) -> Void)?
    
    private lazy var scroll = UIScrollView.create()
    
    private lazy var contentView = UIView()
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.distributeBudgetLabel(), fontSize: FontSizeConstans.title,
                                         weight: .medium)
    private lazy var inputSumLabel = UILabel.create(text: R.string.localizable.inputBudgetLabel(), fontSize: FontSizeConstans.body,
                                                    weight: .medium)
    private lazy var setupCategoriesLabel = UILabel.create(text: R.string.localizable.setupCategoryLabel(), fontSize: FontSizeConstans.body,
                                                           weight: .medium)
    
    private lazy var inputSumTextField = AmountTextField()
    
    private lazy var productsCategoryView = ItemView(title: R.string.localizable.productsCategoryButton(), iconName: R.image.food_icon.name,
                                                     iconColor: .systemGreen) { [weak self] in
        self?.clickOnCategory?(R.string.localizable.productsCategoryButton(), R.image.food_icon.name, .systemGreen)
    }
    
    private lazy var transportCategoryView = ItemView(title: R.string.localizable.transportCategoryButton(),
                                                      iconName: R.image.transport_icon.name, iconColor: .systemBlue) { [weak self] in
        self?.clickOnCategory?(R.string.localizable.transportCategoryButton(), R.image.transport_icon.name, .systemBlue)
    }

    private lazy var utilitiesCategoryView = ItemView(title: R.string.localizable.utilitiesCategoryButton(), iconName: R.image.faucet_icon.name,
                                                      iconColor: .systemYellow) { [weak self] in
        self?.clickOnCategory?(R.string.localizable.utilitiesCategoryButton(), R.image.faucet_icon.name, .systemYellow)
    }

    private lazy var divorcesCategoryView = ItemView(title: R.string.localizable.divorcesCategoryButton(), iconName: R.image.event_icon.name,
                                                     iconColor: .systemPurple) { [weak self] in
        self?.clickOnCategory?(R.string.localizable.divorcesCategoryButton(), R.image.event_icon.name, .systemPurple)
    }

    private lazy var accumulationsCategoryView = ItemView(title: R.string.localizable.accumulationsCategoryButton(),
                                                          iconName: R.image.coins_icon.name, iconColor: .systemOrange) { [weak self] in
        self?.clickOnCategory?(R.string.localizable.accumulationsCategoryButton(), R.image.coins_icon.name, .systemOrange)
    }

    private lazy var otherCategoryView = ItemView(title: R.string.localizable.otherCategoryButton(), iconName: R.image.other_icon.name,
                                                  iconColor: .systemGray) { [weak self] in
        self?.clickOnCategory?(R.string.localizable.otherCategoryButton(), R.image.other_icon.name, .systemGray)
    }

    private lazy var categoryStack = UIStackView.create(stackSpacing: Constans.mediumStackSpacing,
                                                        views: [productsCategoryView, transportCategoryView,
    utilitiesCategoryView, divorcesCategoryView, accumulationsCategoryView, otherCategoryView])
    
    private lazy var confirmButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmationButton())) { [weak self] in
        self?.clickOnConfirmButton?()
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
        addSubview(scroll)
        scroll.addSubview(contentView)
        contentView.addSubviews(inputSumLabel, inputSumTextField, setupCategoriesLabel, categoryStack, confirmButton)
        
        scroll.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        inputSumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constans.insetLarge)
            make.leading.equalTo(inputSumTextField.snp.leading).inset(Constans.textFieldContentInset)
        }
        
        inputSumTextField.snp.makeConstraints { make in
            make.top.equalTo(inputSumLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.height.equalTo(Constans.heightButtonMedium)
        }
        
        setupCategoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(inputSumTextField.snp.bottom).offset(Constans.insetXLarge)
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
