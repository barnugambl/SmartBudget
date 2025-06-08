//
//  TextField+.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.05.2025.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
    
    func notifyTextChanged() {
           NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
    }
}
