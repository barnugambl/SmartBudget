//
//  AppCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var finanicalGoalViewModel = FinancialGoalViewModel()
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func showMainTabBar() {
        let tabBarController = CustomTabBarController()
        
        
        let goalsVM = finanicalGoalViewModel
        

        let goalsVC = UINavigationController(rootViewController: FinancialGoalsViewController(viewModel: goalsVM))
        let goals = goalsVC.viewControllers[0] as? FinancialGoalsViewController
   
        
        goals?.coordinator = self
        
        tabBarController.viewControllers = [goalsVC]
        tabBarController.setupTabBar()
        navigationController.setViewControllers([tabBarController], animated: true)
    }
        
    func start() {
        showMainTabBar()
    }
    
    func showAddFinancialGoalScreen() {
        let vc = AddFinancialGoalViewController(viewModel: finanicalGoalViewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
        
    func showFinancialGoalScreen() {
        let vc = FinancialGoalsViewController(viewModel: finanicalGoalViewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddMoneyScreen(name: String) {
        let viewModel = AddMoneyFinancialGoalViewModel()
        let vc = AddMoneyFinancialGoalViewController(viewModel: viewModel, name: name)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
