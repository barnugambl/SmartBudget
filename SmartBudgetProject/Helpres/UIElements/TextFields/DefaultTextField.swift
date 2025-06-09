//
//  CustomTextField.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import UIKit

final class DefaultTextField: UITextField {
    private var isPassword: Bool
    private var fieldPlaceHolder: String
    private var keyType: UIKeyboardType
    private var fieldBackgroundColor: UIColor
    private var cornerRadius: CGFloat
    private var textPlaceHolderSize: CGFloat
    private var textPlaceHolderColor: UIColor
    private var textPlaceHolderWeight: UIFont.Weight
    
    init(fieldPlaceHodler: String,
         isPassword: Bool = false,
         keyType: UIKeyboardType = .default,
         fieldBackgroundColor: UIColor = .systemGray6,
         cornerRadius: CGFloat = 10,
         textPlaceHolderSize: CGFloat = 14,
         textPlaceHolderColor: UIColor = .placeholderText,
         textPlaceHolderWeight: UIFont.Weight = .regular,
         frame: CGRect = .zero) {
        
        self.isPassword = isPassword
        self.fieldPlaceHolder = fieldPlaceHodler
        self.keyType = keyType
        self.cornerRadius = cornerRadius
        self.fieldBackgroundColor = fieldBackgroundColor
        self.textPlaceHolderSize = textPlaceHolderSize
        self.textPlaceHolderColor = textPlaceHolderColor
        self.textPlaceHolderWeight = textPlaceHolderWeight
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        isSecureTextEntry = isPassword
        leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 1))
        leftViewMode = .always
        keyboardType = keyType
        textColor = .label
        backgroundColor = fieldBackgroundColor
        layer.cornerRadius = cornerRadius
        inputAccessoryView = createToolbar()
        attributedPlaceholder = NSAttributedString(
            string: fieldPlaceHolder,
            attributes: [
                .font: UIFont.systemFont(ofSize: textPlaceHolderSize, weight: textPlaceHolderWeight),
                .foregroundColor: textPlaceHolderColor
            ]
        )
        if isSecureTextEntry {
            rightView = setupRightView()
            rightViewMode = .always
        }
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(dismissKeyboard))
        
        toolbar.items = [flexSpace, doneButton]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
    
    private func setupRightView() -> UIView {
        let view = UIView(frame: .init(x: 0, y: 0, width: 30, height: 30))
        let eyeButton = UIButton(type: .system)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .systemGray2
        eyeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.isSecureTextEntry.toggle()
            let imageName = self.isSecureTextEntry ? "eye.slash" : "eye"
            eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }), for: .touchUpInside)
        eyeButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        view.addSubview(eyeButton)
        return view
    }
}
