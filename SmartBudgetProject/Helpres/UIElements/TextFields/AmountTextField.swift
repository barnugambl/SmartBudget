import UIKit

final class AmountTextField: UITextField {
    private let currencySymbol = "₽"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        leftViewMode = .always
        backgroundColor = .systemGray2
        layer.cornerRadius = 25
        keyboardType = .numberPad
        font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        textColor = .systemBackground
        delegate = self

        let placeholderText = "0 \(currencySymbol)"
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .font: font ?? UIFont(),
                .foregroundColor: textColor ?? .systemBackground
            ]
        )
    }
    
    private func formatAmount(_ string: String) -> String {
        let cleanString = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        guard !cleanString.isEmpty else { return "" }
        guard let number = Int(cleanString) else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: number)).map { "\($0) \(currencySymbol)" } ?? ""
    }
}

extension AmountTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let cleanText = newText.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        guard cleanText.count <= 8 else { return false }
        
        let formatted = formatAmount(cleanText)
        textField.text = formatted
        textField.notifyTextChanged()
        
        if let newCursorPosition = calculateCursorPosition(in: textField, offsetFromEnd: formatted.count - (cleanText.isEmpty ? 0 : 2)) {
            textField.selectedTextRange = newCursorPosition
        }
        
        return false
    }
    
    private func calculateCursorPosition(in textField: UITextField, offsetFromEnd offset: Int) -> UITextRange? {
        guard let position = textField.position(from: textField.beginningOfDocument, offset: offset) else {
            return nil
        }
        return textField.textRange(from: position, to: position)
    }
}
