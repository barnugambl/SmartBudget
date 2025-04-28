//
//  AppCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showMainTabBar() {
        let tabBarController = CustomTabBarController()
        
        let expensesVC = ExpensesViewController(viewModel: ExpensesViewModel())
        let goalsVC = UINavigationController(rootViewController: FinancialGoalsViewController(
            viewModel: FinancialGoalViewModel()))
        
        let profileVC = ProfileViewController(viewModel: ProfileViewModel())
        
        expensesVC.coordinator = self
        let goal = goalsVC.viewControllers[0] as? FinancialGoalsViewController
        goal?.coordinator = self
        profileVC.coordinator = self
        
        tabBarController.viewControllers = [expensesVC, goalsVC, profileVC]
        tabBarController.setupTabBar()
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func start() {
        let viewModel = LogViewModel()
        let logVC = LogViewConroller(viewModel: viewModel)
        logVC.coordinator = self
        navigationController.pushViewController(logVC, animated: true)
    }
    
    func showLogScreen() {
        let viewModel = LogViewModel()
        let vc = LogViewConroller(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showRegScreen() {
        let viewModel = RegViewModel()
        let vc = RegViewConroller(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPasswordRecoveryScreen() {
        let viewModel = PasswordRecoveryViewModel()
        let vc = PasswordRecoveryViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCheckNumberPhoneScreen() {
        let viewModel = CheckNumberPhoneViewModel()
        let vc = CheckNumberPhonelViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNewPasswordScreen() {
        let viewModel = NewPasswordViewModel()
        let vc = NewPasswordViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProfileScreen() {
        let viewModel = ProfileViewModel()
        let vc = ProfileViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditProfileScreen() {
        let viewModel = EditProfileViewModel()
        let vc = EditProfileViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSetupCategoryScreen() {
        let viewModel = SetupCategoryViewModel()
        let vc = SetupCategoryViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddFinancialGoalScreen() {
        let viewModel = AddFinancialGoalViewModel()
        let vc = AddFinancialGoalViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showInitialBudgetScreen() {
        let viewModel = InitialBudgetViewModel()
        let vc = InitialBudgetViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFinancialGoalScreen() {
        let viewModel = FinancialGoalViewModel()
        let vc = FinancialGoalsViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showExpensesScreen() {
        let viewModel = ExpensesViewModel()
        let vc = ExpensesViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
