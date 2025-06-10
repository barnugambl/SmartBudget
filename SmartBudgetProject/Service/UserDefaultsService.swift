//
//  UserDefaultsService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation
import UIKit

final class UserDefaultsService {
    private let userDefaults: UserDefaults
    
    static let shared = UserDefaultsService()
    
    private enum Keys {
        static let isLogged = "isLogged"
        static let isDarkTheme = "isDarkTheme"
        static let selectedLanguage = "selectedLanguage"
    }
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        updateTheme()
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
            updateTheme()
        }
    }
    
    func setDarkTheme(_ isOn: Bool) {
        isDarkTheme = isOn
    }
    
    func updateTheme() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            windowScene?.windows.forEach { window in
                window.overrideUserInterfaceStyle = self.isDarkTheme ? .dark : .light
            }
        }
    }
}

// MARK: Language
extension UserDefaultsService {
    private static let defaultLanguageCode = "ru"

    var selectedLanguage: String {
        get {
            userDefaults.string(forKey: Keys.selectedLanguage) ?? Self.defaultLanguageCode
        }
        set {
            userDefaults.set(newValue, forKey: Keys.selectedLanguage)
            userDefaults.synchronize()
        }
    }
}
