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
