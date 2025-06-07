//
//  ScreenFactory.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

final class ModuleBulder {
    func makeRegScreen() -> RegViewConroller {
        let viewModel = RegViewModel()
        return RegViewConroller(viewModel: viewModel)
    }
    
    func makePasswordRecoveryScreen() -> PasswordRecoveryViewController {
        let viewModel = PasswordRecoveryViewModel()
        return PasswordRecoveryViewController(viewModel: viewModel)
    }
    
    func makeCheckPhoneScreen(type: ConfirmationFlow) -> CheckNumberPhonelViewController {
        let viewModel = CheckNumberPhoneViewModel()
        return CheckNumberPhonelViewController(viewModel: viewModel, type: type)
    }
    
    func makeCreatePasswordScreen() -> CreatePasswordViewController {
        let viewModel = CreatePasswordViewModel()
        return CreatePasswordViewController(viewModel: viewModel)
    }
    
    func makeCreateNewPasswordScreen() -> CreateNewPasswordViewController {
        let viewModel = CreateNewPasswordViewModel()
        return CreateNewPasswordViewController(viewModel: viewModel)
    }
    
    func makeProfileScreen() -> ProfileViewController {
        let viewModel = ProfileViewModel()
        return ProfileViewController(viewModel: viewModel)
    }
    
    func makeEditProfileScreen() -> EditProfileViewController {
        let viewModel = EditProfileViewModel()
        return EditProfileViewController(viewModel: viewModel)
    }
    
}
