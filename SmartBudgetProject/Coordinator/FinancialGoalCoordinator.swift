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
    
    private let moduleBulder = ModuleBulder()
    
    private let viewModel = FinancialGoalViewModel(userId: 1, goalId: 1, financilGoaSevice: FinancialGoalAPIService(apiService: ApiService()))
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFinancialFlow()
    }
    
    private func showFinancialFlow() {
        let financialGoalVC = moduleBulder.makeFinancialGoalScreen(viewModel: viewModel)
        financialGoalVC.coordinator = self
        navigationController.setViewControllers([financialGoalVC], animated: false)
    }
    
    func showAddFinancialGoalFlow() {
        let addFinancialGoalVC = moduleBulder.makeAddFinancialGoalScreen(viewModel: viewModel)
        addFinancialGoalVC.coordinator = self
        navigationController.pushViewController(addFinancialGoalVC, animated: true)
    }
    
    func showAddMoneyFinancialGoalFlow(nameGoal: String, userId: Int) {
        let addMoneyFinancialGoalVC = moduleBulder.makeAddMoneyFinancialGoalScreen(viewModel: viewModel, nameGoal: nameGoal, userId: userId)
        addMoneyFinancialGoalVC.coordinator = self
        navigationController.pushViewController(addMoneyFinancialGoalVC, animated: true)
    }
}
