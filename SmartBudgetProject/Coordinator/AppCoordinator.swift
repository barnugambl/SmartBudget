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
        
        let expensesVM = ExpensesViewModel()
        let expensesVC = ExpensesViewController(viewModel: expensesVM)
             
        expensesVC.coordinator = self
 
        tabBarController.viewControllers = [expensesVC]
        tabBarController.setupTabBar()
        navigationController.setViewControllers([tabBarController], animated: true)
    }
        
    func start() {
        showMainTabBar()
    }
    
    func showExpensesScreen() {
        let viewModel = ExpensesViewModel()
        let vc = ExpensesViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
