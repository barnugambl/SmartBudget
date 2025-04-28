//
//  InitialBudgetView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit

class InitialBudgetView: UIView {
        
    private lazy var titleLabel = Label(textLabel: R.string.localizable.distributeBudgetLabel(),
                                        textSize: 24, weight: .medium)
    
    private lazy var inputSumLabel = Label(textLabel:  R.string.localizable.inputBudgetLabel(),
                                           textSize: 16, weight: .medium)
    
    private lazy var inputSumTextField = TextField(fieldPlaceHodler: R.string.localizable.inputBudgetTextFIeld(),
                                                   fieldBackgroundColor: .systemGray3,
                                                   cornerRadius: 25,
                                                   textPlaceHolderSize: 25,
                                                   textPlaceHolderColor: .white,
                                                   textPlaceHolderWeight: .heavy)
    
    private lazy var setupCategoriesLabel = Label(textLabel:  R.string.localizable.setupCategoryLabel(),
                                                  textSize: 16,
                                                  weight: .medium)
    
    private lazy var productsCategoryButton = ListButton(title: R.string.localizable.productsCategoryButton(),
                                                         nameImage: R.image.food_icon.name,
                                                         iconColor: .systemGreen) { }
    
    private lazy var transportCategoryButton = ListButton(title: R.string.localizable.transportCategoryButton(),
                                                          nameImage: R.image.transport_icon.name,
                                                          iconColor: .systemBlue) { }
    
    private lazy var utilitiesCategoryButton = ListButton(title: R.string.localizable.utilitiesCategoryButton(),
                                                          nameImage: R.image.faucet_icon.name,
                                                          iconColor: .systemYellow) { }
    
    private lazy var divorcesCategoryButton = ListButton(title: R.string.localizable.divorcesCategoryButton(),
                                                         nameImage: R.image.event_icon.name,
                                                         iconColor: .systemPurple) { }
    
    private lazy var accumulationsCategoryButton = ListButton(title: R.string.localizable.accumulationsCategoryButton(),
                                                              nameImage: R.image.coins_icon.name,
                                                              iconColor: .systemOrange) { }
    
    private lazy var otherCategoryButton = ListButton(title: R.string.localizable.otherCategoryButton(),
                                                      nameImage: R.image.other_icon.name,
                                                      iconColor: .systemGray) { }
        
    private lazy var categoryStack = Stack(stackSpaicing: 20, views: [productsCategoryButton, transportCategoryButton, utilitiesCategoryButton, divorcesCategoryButton, accumulationsCategoryButton,
        otherCategoryButton])
    
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
        addSubviews(titleLabel, inputSumLabel, inputSumTextField,setupCategoriesLabel, categoryStack)
                
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        inputSumLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalTo(inputSumTextField.snp.leading).offset(8)
        }
        
        inputSumTextField.snp.makeConstraints { make in
            make.top.equalTo(inputSumLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
                
        setupCategoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(inputSumTextField.snp.bottom).offset(40)
            make.leading.equalTo(inputSumTextField.snp.leading).offset(8)
        }
        
        categoryStack.snp.makeConstraints { make in
            make.top.equalTo(setupCategoriesLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        categoryStack.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(60)
        }})
    }
}
