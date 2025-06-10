//
//  ProfileViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation

final class ProfileViewModel {

    func toggleDarkTheme(isOn: Bool) {
        UserDefaultsService.shared.setDarkTheme(isOn)
    }
}

