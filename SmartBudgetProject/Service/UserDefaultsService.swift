//
//  UserDefaultsService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

final class UserDefaultsService {
    private let userDefaults: UserDefaults

    static let shared = UserDefaultsService()
        
    private enum Keys {
        static let isLogged = "isLogged"
        static let userId = "userId"
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveAuthData(userId: Int, accessToken: String, refreshToken: String) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clearAuthData() {
        userDefaults.removeObject(forKey: Keys.accessToken)
        userDefaults.removeObject(forKey: Keys.isLogged)
        userDefaults.removeObject(forKey: Keys.refreshToken)
        userDefaults.removeObject(forKey: Keys.userId)
     }
}

// MARK: IsLogged
extension UserDefaultsService {
    var isFirstLaunch: Bool {
        get { userDefaults.bool(forKey: Keys.isLogged) }
        set { userDefaults.set(newValue, forKey: Keys.isLogged) }
    }
}

// MARK: Auth Data
extension UserDefaultsService {
    var userId: Int? {
        get { userDefaults.integer(forKey: Keys.userId) }
        set { userDefaults.set(newValue, forKey: Keys.userId) }
    }
    
    var accessToken: String? {
        get { userDefaults.string(forKey: Keys.accessToken) }
        set { userDefaults.set(newValue, forKey: Keys.accessToken) }
    }
    
    var refreshToken: String? {
        get { userDefaults.string(forKey: Keys.refreshToken) }
        set { userDefaults.set(newValue, forKey: Keys.refreshToken) }
    }
}
