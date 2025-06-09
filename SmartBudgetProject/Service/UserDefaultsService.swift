//
//  UserDefaultsService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation
import UIKit

class UserDefaultsService {
    private let userDefaults: UserDefaults
    
    static let shared = UserDefaultsService()
    
    private enum Keys {
        static let isLogged = "isLogged"
        static let isDarkTheme = "isDarkTheme"
    }
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

// MARK: IsLogged
extension UserDefaultsService {
    var isLogged: Bool {
        get { userDefaults.bool(forKey: Keys.isLogged) }
        set {
            userDefaults.set(newValue, forKey: Keys.isLogged)
            userDefaults.synchronize()
        }
    }
}

// MARK: DarkTheme
extension UserDefaultsService {
    var isDarkTheme: Bool {
        get { userDefaults.bool(forKey: Keys.isDarkTheme) }
        set {
            userDefaults.set(newValue, forKey: Keys.isDarkTheme)
            userDefaults.synchronize()
        }
    }
}
