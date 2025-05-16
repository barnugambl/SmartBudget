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
    
    func makeLoginScreen() -> LogViewConroller {
        let viewModel = LogViewModel()
        return LogViewConroller(viewModel: viewModel)
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
    
    func makeAddFinancialGoalScreen(viewModel: FinancialGoalViewModel) -> AddFinancialGoalViewController {
        return AddFinancialGoalViewController(viewModel: viewModel)
    }
    
    func makeAddMoneyFinancialGoalScreen(viewModel: FinancialGoalViewModel, nameGoal: String) -> AddMoneyFinancialGoalViewController {
        return AddMoneyFinancialGoalViewController(viewModel: viewModel, nameGoal: nameGoal)
    }
    
    func makeExpensesScreen() -> ExpensesViewController {
        let viewModel = ExpensesViewModel()
        return ExpensesViewController(viewModel: viewModel)
    }
    
    func makeProfileScreen() -> ProfileViewController {
        let viewModel = ProfileViewModel()
        return ProfileViewController(viewModel: viewModel)
    }
    
    func makeFinancialGoalScreen(viewModel: FinancialGoalViewModel) -> FinancialGoalsViewController {
        return FinancialGoalsViewController(viewModel: viewModel)
    }
    
    func makeInitialBudgetScreen() -> InitialBudgetViewController {
        let viewModel = InitialBudgetViewModel()
        return InitialBudgetViewController(viewModel: viewModel)
    }
    
    func setupCategoryScreen() -> SetupPersentViewController {
        let viewModel = SetupPresentViewModel()
        return SetupPersentViewController(viewModel: viewModel)
    }
    
    func makeEditProfileScreen() -> EditProfileViewController {
        let viewModel = EditProfileViewModel()
        return EditProfileViewController(viewModel: viewModel)
    }
    
    func makeSetupCategoryScreen(title: String, iconName: String, iconColor: UIColor) -> SetupCategoryViewController {
        let viewModel = SetupCategoryViewModel()
        return SetupCategoryViewController(viewModel: viewModel, title: title, iconName: iconName, iconColor: iconColor)
    }
    
    func makeSetupPersentScreen() -> SetupPersentViewController {
        let viewModel = SetupPresentViewModel()
        return SetupPersentViewController(viewModel: viewModel)
    }
}
