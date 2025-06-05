//
//  String.ext.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import Foundation

extension String {
    var digitsOnly: String {
        replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
}

// MARK: UserDefaults key
extension String {
    static let loggedIn = "loggedIn"
}
