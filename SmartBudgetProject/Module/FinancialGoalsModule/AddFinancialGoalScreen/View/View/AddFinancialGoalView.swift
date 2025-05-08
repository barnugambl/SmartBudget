//
//  AddFanancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit


class AddFinancialGoalView: UIView {
    
    var onClickButton: (() -> Void)?
    
    private lazy var titleLabel = Label(textLabel: R.string.localizable.addFinancialGoalLabel(),
                                        textSize: 24, weight: .medium)
    
    lazy var nameGoalTextField = DefaultTextField(
        fieldPlaceHodler: R.string.localizable.nameFinancialGoalTextField())
    
    lazy var sumGoalTextField = AmountTextField()
    
    private lazy var nameSumGoalStackView = Stack(stackSpaicing: 20,
        views: [nameGoalTextField, sumGoalTextField])
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    lazy var dateTextFieldLabel = Label(textLabel: "Дата окончания",
                                                textSize: 16, weight: .medium)
    private lazy var dateStack = Stack(views: [dateTextFieldLabel, dateTextField])
    
    lazy var dateTextField: UITextField = {
        let field = UITextField()
        let leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 1))
        field.leftView = leftView
        field.leftViewMode = .always
        
        field.placeholder = "Конец"
        field.backgroundColor = .systemGray6
        field.layer.cornerRadius = 20
        
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        let paddingView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 20))
        imageView.frame = CGRect(x: -1, y: 0, width: 20, height: 20)
        paddingView.addSubview(imageView)
        field.rightView = paddingView
        field.rightViewMode = .always
        return field
    }()
    
    private lazy var confirmationButton = DefaultButton(title: "Подтвердить") { [weak self] in
        self?.onClickButton?()
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
        addSubviews(titleLabel, nameSumGoalStackView, separatorView,
                    dateTextFieldLabel, dateTextField, confirmationButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
        }
        
        nameSumGoalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nameSumGoalStackView.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(56)
        }})
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(nameSumGoalStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        dateTextFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.leading.equalTo(dateTextField.snp.leading).offset(10)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextFieldLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(UIScreen.main.bounds.width / 2.5)
            make.height.equalTo(56)
        }
        
        confirmationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(48)
        }
    }
}
