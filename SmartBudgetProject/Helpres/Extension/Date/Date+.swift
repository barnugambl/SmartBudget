//
//  Date.ext.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation

extension Date {
    static func formated(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

extension Date {
    static func from(string: String, format: String = "dd.MM.yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.date(from: string)
    }
}
extension Date {
    static func convertToServerFormat(from input: String) -> String? {
        let cleaned = input.replacingOccurrences(of: "\u{202F}г.", with: "").trimmingCharacters(in: .whitespaces)

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ru_RU")
        inputFormatter.dateFormat = "d MMMM yyyy"

        guard let date = inputFormatter.date(from: cleaned) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        return outputFormatter.string(from: date)
    }
}

