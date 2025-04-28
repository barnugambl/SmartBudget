//
//  AddFanancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

class AddFinancialGoalView: UIView {
    
    private lazy var titleLabel = Label(textLabel: R.string.localizable.addFinancialGoalLabel(),
                                        textSize: 24, weight: .medium)
    
    private lazy var nameGoalTextField = TextField(
        fieldPlaceHodler: R.string.localizable.nameFinancialGoalTextField())
    
    private lazy var sumGoalTextField = TextField(
        fieldPlaceHodler: R.string.localizable.budgetFinancialGoalTextField(),
        fieldBackgroundColor: .systemGray2,
        cornerRadius: 25,
        textPlaceHolderSize: 20,
        textPlaceHolderColor: .white,
        textPlaceHolderWeight: .heavy)
    
    private lazy var nameSumGoalStackView = Stack(stackSpaicing: 20,
        views: [nameGoalTextField, sumGoalTextField])
    
    
    
    
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
        addSubviews(titleLabel, nameSumGoalStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        nameSumGoalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nameSumGoalStackView.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(56)
        }})
    }
}
