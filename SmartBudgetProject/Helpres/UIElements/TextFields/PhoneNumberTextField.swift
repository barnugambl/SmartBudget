import UIKit

final class PhoneNumberTextField: UITextField {
    private let placeholderText = "Введите номер телефона"
    private let prefix = "+7 "
    
    var cleanPhoneNumber: String {
        guard let text = self.text else { return "" }
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 1))
        leftViewMode = .always
        textColor = .black
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
                
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.systemGray2
            ]
        )
        
        delegate = self
        keyboardType = .phonePad
    }
}

extension PhoneNumberTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if string.isEmpty {
            if text == prefix && range.length > 0 {
                textField.text = ""
                textField.attributedPlaceholder = NSAttributedString(
                    string: placeholderText,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                        .foregroundColor: UIColor.systemGray2
                    ]
                )
                return false
            }
            return true
        }
        
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let currentDigits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let newDigits = currentDigits + string
        
        if newDigits.count > 11 {
            return false
        }
        
        if text.isEmpty {
            textField.text = prefix
        }
        
        textField.text = formatPhoneNumber(newDigits)
        
        return false
    }
    
    private func formatPhoneNumber(_ digits: String) -> String {
        var result = prefix
        let cleanDigits = digits.count <= 1 ? digits : String(digits.dropFirst())
        
        for (index, digit) in cleanDigits.enumerated() {
            switch index {
            case 0...2:
                if index == 3 { result += " " }
                result.append(digit)
            case 3...5:
                if index == 3 { result += " " }
                result.append(digit)
            case 6...7:
                if index == 6 { result += "-" }
                result.append(digit)
            case 8...9:
                if index == 8 { result += "-" }
                result.append(digit)
            default:
                break
            }
        }
        
        return result
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                    .foregroundColor: UIColor.systemGray2
                ]
            )
        }
    }
}
