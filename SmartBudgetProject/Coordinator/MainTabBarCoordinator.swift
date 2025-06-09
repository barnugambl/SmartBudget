//
//  MainTabBarCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 11.05.2025.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    private weak var profileDelegate: ProfileCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var tabBarController: CustomTabBarController
    
    init(navigationController: UINavigationController, profileDelegate: ProfileCoordinatorDelegate?) {
        self.navigationController = navigationController
        self.profileDelegate = profileDelegate
        tabBarController = CustomTabBarController()
    }
    
    func start() {
        setupTabs()
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func setupTabs() {
        let expensesNC = UINavigationController()
        let profileNC = UINavigationController()
        let financialGoalNC = UINavigationController()
        
        let expensesCoordinator = ExpensesCoordinator(navigationController: expensesNC)
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
