//
//  Constans.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.05.2025.
//

import Foundation

enum Constans {
    static let mediumStackSpacing: CGFloat = 20
    static let largeStackSpacing: CGFloat = 32
    static let smallStackSpacing: CGFloat = 10
    static let tinyStackSpacing: CGFloat = 8
    
    static let smallHeight: CGFloat = 8
    
    static let insetTiny: CGFloat = 8
    static let insetSmall: CGFloat = 16
    static let insetMedium: CGFloat = 20
    static let insetLarge: CGFloat = 32
    static let insetXLarge: CGFloat = 40
    static let insetXXLarge: CGFloat = 56
    
    static let textFieldContentInset: CGFloat = 10
    
    static let heightButton: CGFloat = 48
    static let heightSpinner: CGFloat = 48
    static let heightTextField: CGFloat = 48
    static let heightTextFieldMedium: CGFloat = 56
    static let heightButtonMedium: CGFloat = 56
    static let heightItemView: CGFloat = 60
    
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 20
}

// MARK: fontSize
enum FontSizeConstans {
    static let title: CGFloat = 24
    static let heading: CGFloat = 20
    static let body: CGFloat = 16
    static let subbody: CGFloat = 14    
    static let caption: CGFloat = 12
}

enum ColorConstans {
    static let yellow = "FFDD2D"
}

enum URLConstansBudget {
    static let setupBudgetURL = "/budget"
    
    static func getBudgetURL(userId: Int) -> String {
        return "/budget/status/\(userId)"
    }
    
    static func updateBudgetURL(userId: Int) -> String {
        return "/budget/\(userId)"
    }
}

enum URLConstansNotification {
    static func getNotification(userId: Int) -> String {
        return "/notifications/\(userId)"
    }
}

enum URLConstantLogin {
    static let login = "/login"
}
 
