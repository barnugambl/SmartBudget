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
        let expensesVC = budgetBulder.makeExpensesScreen()
        navigationController.setViewControllers([expensesVC], animated: false)
    }
}
