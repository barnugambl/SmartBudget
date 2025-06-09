//
//  ExpensesCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

final class ExpensesCoordinator: Coordinator {
    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []
    
    private let budgetBulder = BudgetScreenBulder.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showExpensesFlow()
    }
    
    func showExpensesFlow() {
        let expensesVC = budgetBulder.makeBudgetScreen()
        expensesVC.coordinator = self
        navigationController.setViewControllers([expensesVC], animated: false)
    }
    
    func showTransactionFlow(name: String) {
        let transtactionVC = budgetBulder.makeTranstactionScreen(name: name)
        transtactionVC.coordinator = self
        navigationController.pushViewController(transtactionVC, animated: true)
    }
}
