//
//  FinancialGoalCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

final class FinancialGoalCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private let moduleBulder = FinancialGoalScreenBulder.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFinancialFlow()
    }
    
    private func showFinancialFlow() {
        let financialGoalVC = moduleBulder.makeFinancialGoalScreen()
        financialGoalVC.coordinator = self
        navigationController.setViewControllers([financialGoalVC], animated: false)
    }
    
    func showAddFinancialGoalFlow() {
        let addFinancialGoalVC = moduleBulder.makeAddFinancialGoalScreen()
        addFinancialGoalVC.coordinator = self
        navigationController.pushViewController(addFinancialGoalVC, animated: true)
    }
    
    func showAddMoneyFinancialGoalFlow(goal: Goal) {
        let addMoneyFinancialGoalVC = moduleBulder.makeAddMoneyFinancialGoalScreen(goal: goal)
        addMoneyFinancialGoalVC.coordinator = self
        navigationController.pushViewController(addMoneyFinancialGoalVC, animated: true)
    }
    
    func showEditFinancialGoal(goal: Goal) {
        let edtiFinancialGoalVC = moduleBulder.makeEditFinancialGoalScreen(goal: goal)
        edtiFinancialGoalVC.coordinator = self
        navigationController.pushViewController(edtiFinancialGoalVC, animated: true)
    }
}
