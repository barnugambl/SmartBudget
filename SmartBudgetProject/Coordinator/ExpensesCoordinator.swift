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
    
    private let budgetBulder: BudgetScreenBulder
    
    init(navigationController: UINavigationController, budgetBulder: BudgetScreenBulder) {
        self.navigationController = navigationController
        self.budgetBulder = budgetBulder
    }
    
    func start() {
        showExpensesFlow()
    }
    
    func showExpensesFlow() {
        let expensesVC = budgetBulder.makeBudgetScreen()
        navigationController.setViewControllers([expensesVC], animated: false)
    }
}
