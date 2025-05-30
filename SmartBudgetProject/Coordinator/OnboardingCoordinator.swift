//
//  OnboardingCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinishOnBoarding(coordinator: Coordinator)
}

final class OnboardingCoordinator: Coordinator {
    private let budgetBulder = BudgetScreenBulder.shared

    weak var delegate: OnboardingCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showInitialBudgetScreen()
    }
    
    func showInitialBudgetScreen() {
        let initialBudgetVC = budgetBulder.makeInitialBudgetScreen()
        initialBudgetVC.coordinator = self
        navigationController.setViewControllers([initialBudgetVC], animated: true)
    }
    
    func showSetupCategoryScreen(category: CategoryDto) {
        let setupCategoryVC = budgetBulder.makeSetupCategoryScreen(category: category)
        setupCategoryVC.coordinator = self
        navigationController.pushViewController(setupCategoryVC, animated: true)
    }
    
    func showSetupPersentScreen(categories: [CategoryDto]) {
        let setupPersentVC = budgetBulder.makeSetupPersentScreen(categories: categories)
        setupPersentVC.coordinator = self
        navigationController.pushViewController(setupPersentVC, animated: true)
    }
    
    func finishOnBoarding() {
        delegate?.didFinishOnBoarding(coordinator: self)
    }
}
