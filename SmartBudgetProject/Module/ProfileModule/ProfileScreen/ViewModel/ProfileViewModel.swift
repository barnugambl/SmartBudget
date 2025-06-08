//
//  ProfileViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation

class ProfileViewModel {
    private let coreDataManager = UserCoreDataManager.shared
 
    func getCurrentUser() -> UserCD? {
        return coreDataManager.getCurrentUser()
    }
    
    func exitUser() {
        UserDefaultsService.shared.isLogged = false
        coreDataManager.clearUserData()
    }
}
