//
//  MainTabBarCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 11.05.2025.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    private weak var profileDelegate: ProfileCoordinatorDelegate?
    private let budgetBulder: BudgetScreenBulder
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var tabBarController: CustomTabBarController
        
    init(navigationController: UINavigationController, profileDelegate: ProfileCoordinatorDelegate?, budgetBulder: BudgetScreenBulder) {
        self.navigationController = navigationController
        self.profileDelegate = profileDelegate
        self.budgetBulder = budgetBulder
        tabBarController = CustomTabBarController()
    }
    
    func start() {
        setupTabs()
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func setupTabs() {
        let expensesNC = UINavigationController()
        let profileNC = UINavigationController()
        let financialGoalNC = UINavigationController()
        
        let expensesCoordinator = ExpensesCoordinator(navigationController: expensesNC, budgetBulder: budgetBulder)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNC)
        let finanicalGoalCoordinator = FinancialGoalCoordinator(navigationController: financialGoalNC)
        
        profileCoordinator.delegate = profileDelegate
        
        childCoordinators.append(expensesCoordinator)
        childCoordinators.append(profileCoordinator)
        childCoordinators.append(finanicalGoalCoordinator)
        
        expensesCoordinator.start()
        profileCoordinator.start()
        finanicalGoalCoordinator.start()
        
        tabBarController.viewControllers = [expensesNC, financialGoalNC, profileNC]
        tabBarController.setupTabBar()
    }
}

