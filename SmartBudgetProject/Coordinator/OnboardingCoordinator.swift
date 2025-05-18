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
    weak var delegate: OnboardingCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private let moduleBulder = ModuleBulder()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showInitialBudgetScreen()
    }
    
    func showInitialBudgetScreen() {
        let initialBudgetVC = moduleBulder.makeInitialBudgetScreen()
        initialBudgetVC.coordinator = self
        navigationController.setViewControllers([initialBudgetVC], animated: true)
    }
    
    func showSetupCategoryScreen(title: String, iconName: String, iconColor: UIColor) {
        let setupCategoryVC = moduleBulder.makeSetupCategoryScreen(title: title, iconName: iconName, iconColor: iconColor)
        setupCategoryVC.coordinator = self
        navigationController.pushViewController(setupCategoryVC, animated: true)
    }
    
    func showSetupPersentScreen() {
        let setupPersentVC = moduleBulder.makeSetupPersentScreen()
        setupPersentVC.coordinator = self
        navigationController.pushViewController(setupPersentVC, animated: true)
    }
    
    func finishOnBoarding() {
        delegate?.didFinishOnBoarding(coordinator: self)
    }
}
