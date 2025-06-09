//
//  ThemeService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 09.06.2025.
//

import Foundation
import UIKit

final class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {
        updateTheme()
    }
    
    func setDarkTheme(_ isOn: Bool) {
        UserDefaultsService.shared.isDarkTheme = isOn
        updateTheme()
    }
    
    func updateTheme() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            windowScene?.windows.forEach { window in
                window.overrideUserInterfaceStyle = UserDefaultsService.shared.isDarkTheme ? .dark : .light
            }
        }
    }
}
