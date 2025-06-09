//
//  ProfileViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation

class ProfileViewModel {
    private let coreDataManager = UserCoreDataManager.shared
    private let themeManager: ThemeManager
    
    init(themeManager: ThemeManager = .shared) {
        self.themeManager = themeManager
    }
    
    func toggleDarkTheme(isOn: Bool) {
        themeManager.setDarkTheme(isOn)
    }
}
