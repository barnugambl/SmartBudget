//
//  AddFanancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

final class AddFinancialGoalView: UIView {
    var onClickButton: (() -> Void)?
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.addFinancialGoalLabel(), fontSize: FontSizeConstans.title,
                                                 weight: .medium)
    lazy var dateTextFieldLabel = UILabel.create(text: R.string.localizable.endDateFinancialGoalLabel(), fontSize: FontSizeConstans.body,
                                                 weight: .medium)
    
    lazy var nameGoalTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.nameFinancialGoalTextField())
    lazy var sumGoalTextField = AmountTextField()
    lazy var dateTextField: UITextField = {
        let field = UITextField()
        let leftView = UIView(frame: AddFinancialGoalView.sizeLeftView)
        field.leftView = leftView
        field.leftViewMode = .always
        field.placeholder = R.string.localizable.dateTextFieldPlaceHolder()
        field.backgroundColor = .systemGray6
        field.layer.cornerRadius = Constans.cornerRadiusLarge
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        let paddingView = UIView(frame: AddFinancialGoalView.sizePaddingView)
        imageView.frame = AddFinancialGoalView.rightIconSizeDateTextField
        paddingView.addSubview(imageView)
        field.rightView = paddingView
        field.rightViewMode = .always
        return field
    }()
    
    private lazy var nameSumGoalStackView = UIStackView.create(stackSpacing: Constans.mediumStackSpacing,
                                                               views: [nameGoalTextField, sumGoalTextField])
    private lazy var dateStackView = UIStackView.create(views: [dateTextFieldLabel, dateTextField])
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var confirmationButton = UIButton.create(style: .yellow(title: R.string.localizable.confirmationButton())) { [weak self] in
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
        addSubviews(nameSumGoalStackView, separatorView, dateTextFieldLabel, dateTextField, confirmationButton)
        
        nameSumGoalStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
        }
        
        nameSumGoalStackView.arrangedSubviews.forEach({ $0.snp.makeConstraints { make in
            make.height.equalTo(Constans.heightTextFieldMedium)
        }})
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(nameSumGoalStackView.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(AddFinancialGoalView.heightSeparatorView)
        }
        
        dateTextFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(Constans.insetMedium)
            make.leading.equalTo(dateTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextFieldLabel.snp.bottom).offset(Constans.insetSmall)
            make.leading.equalToSuperview().inset(Constans.insetMedium)
            make.width.equalTo(AddFinancialGoalView.dateWidthTextField)
            make.height.equalTo(Constans.heightTextFieldMedium)
        }
        
        confirmationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightButton)
        }
    }
}

extension AddFinancialGoalView {
    static let heightSeparatorView: CGFloat = 1
    static let rightIconSizeDateTextField: CGRect = CGRect(x: -1, y: 0, width: 20, height: 20)
    static let sizeLeftView = CGRect(x: 0, y: 0, width: 10, height: 1)
    static let sizePaddingView = CGRect(x: 0, y: 0, width: 25, height: 20)
    static let dateWidthTextField = UIScreen.main.bounds.width / 2.5
}
