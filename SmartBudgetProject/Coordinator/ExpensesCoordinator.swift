//
//  ExpensesCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

class ExpensesCoordinator: Coordinator {
    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []
    
    private let moduleBulder = ModuleBulder()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showExpensesFlow()
    }
    
    func showExpensesFlow() {
        let expensesVC = moduleBulder.makeExpensesScreen()
        navigationController.setViewControllers([expensesVC], animated: false)
    }
}
