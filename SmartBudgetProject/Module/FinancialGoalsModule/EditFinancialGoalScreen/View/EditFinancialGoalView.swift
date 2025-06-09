//
//  EditFinancialGoalView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 02.06.2025.
//

import UIKit

final class EditFinancialGoalView: UIView {
    var onClickButton: (() -> Void)?
    
    lazy var titleLabel = UILabel.create(text: R.string.localizable.editGoalLabel(),
                                         fontSize: FontSizeConstans.title, weight: .medium)
    private lazy var errorLabel = UILabel.create(fontSize: FontSizeConstans.caption, weight: .medium, textColor: .systemRed)
    
    private lazy var nameGoalLabel = UILabel.create(text: R.string.localizable.nameLabel(),
                                                  fontSize: FontSizeConstans.subbody, weight: .medium)
    private lazy var amountGoalLabel = UILabel.create(text: R.string.localizable.amountLabel(),
                                                     fontSize: FontSizeConstans.subbody, weight: .medium)
    private lazy var dateLabel = UILabel.create(text: R.string.localizable.dateLabel(),
                                              fontSize: FontSizeConstans.subbody, weight: .medium)
    
    lazy var nameGoalTextField = DefaultTextField(fieldPlaceHodler: R.string.localizable.nameFinancialGoalTextField())
    lazy var amountGoalTextField = AmountTextField()
    lazy var dateTextField: UITextField = {
        let field = UITextField()
        let leftView = UIView(frame: EditFinancialGoalView.sizeLeftView)
        field.leftView = leftView
        field.leftViewMode = .always
        field.placeholder = R.string.localizable.dateTextFieldPlaceHolder()
        field.backgroundColor = .systemGray6
        field.layer.cornerRadius = Constans.cornerRadiusLarge
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        let paddingView = UIView(frame: EditFinancialGoalView.sizePaddingView)
        imageView.frame = EditFinancialGoalView.rightIconSizeDateTextField
        paddingView.addSubview(imageView)
        field.rightView = paddingView
        field.rightViewMode = .always
        return field
    }()
    
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
    
    func hideErrorLabel() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
    
    func setTextLabelError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func updateErrorLabelPosition(for textField: UITextField) {
        addSubviews(errorLabel)
        errorLabel.snp.remakeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(Constans.insetTiny)
            make.leading.equalTo(textField.snp.leading).offset(Constans.textFieldContentInset)
        }
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        errorLabel.isHidden = true
        addSubviews(nameGoalLabel, nameGoalTextField, errorLabel, amountGoalLabel, amountGoalTextField, separatorView,
                    dateLabel, dateTextField, confirmationButton)
        
        nameGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetMedium)
            make.leading.equalTo(nameGoalTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        nameGoalTextField.snp.makeConstraints { make in
            make.top.equalTo(nameGoalLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightTextFieldMedium)
        }
        
        amountGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(nameGoalTextField.snp.bottom).offset(Constans.insetLarge)
            make.leading.equalTo(amountGoalTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        amountGoalTextField.snp.makeConstraints { make in
            make.top.equalTo(amountGoalLabel.snp.bottom).offset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(Constans.heightTextFieldMedium)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(amountGoalTextField.snp.bottom).offset(Constans.insetMedium)
            make.leading.trailing.equalToSuperview().inset(Constans.insetMedium)
            make.height.equalTo(AddFinancialGoalView.heightSeparatorView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(Constans.insetLarge)
            make.leading.equalTo(dateTextField.snp.leading).offset(Constans.textFieldContentInset)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constans.insetTiny)
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

extension EditFinancialGoalView {
    static let heightSeparatorView: CGFloat = 1
    static let rightIconSizeDateTextField: CGRect = CGRect(x: -1, y: 0, width: 20, height: 20)
    static let sizeLeftView = CGRect(x: 0, y: 0, width: 10, height: 1)
    static let sizePaddingView = CGRect(x: 0, y: 0, width: 25, height: 20)
    static let dateWidthTextField = UIScreen.main.bounds.width / 2.5
}
