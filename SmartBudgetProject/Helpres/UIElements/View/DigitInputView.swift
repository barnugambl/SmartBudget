//
//  DigitInputView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import UIKit

class DigitInputView: UIView {
    private var textFields = [UITextField]()
    private let digitsCount: Int
    
    init(digitsCount: Int = 5) {
        self.digitsCount = digitsCount
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        for element in 0..<digitsCount {
            let textField = UITextField()
            textField.borderStyle = .none
            textField.layer.cornerRadius = 8
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemGray3.cgColor
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.tag = element
            stackView.addArrangedSubview(textField)
            textFields.append(textField)
        }
    }
}

extension DigitInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Разрешаем только цифры
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        guard allowedCharacters.isSuperset(of: characterSet) else { return false }
        
        // Ограничение на 1 символ
        guard let text = textField.text, text.count + string.count <= 1 else { return false }
        
        // Автоматический переход к следующему полю
        if !string.isEmpty {
            textField.text = string
            if textField.tag < textFields.count - 1 {
                textFields[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
        
        return true
    }
}
