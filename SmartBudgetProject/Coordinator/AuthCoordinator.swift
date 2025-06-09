//
//  AuthCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 11.05.2025.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishAuthFlow(coordinator: AuthCoordinator)
}

final class AuthCoordinator: Coordinator {
    weak var delegate: AuthCoordinatorDelegate?
    private let loginBulder = LoginScreenBulder()
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginFlow()
    }
    
    func startOnBoardingFlow() {
        let onBoardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onBoardingCoordinator.delegate = self
        childCoordinators.append(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
    
    func showLoginFlow() {
        let loginVC = loginBulder.makeLoginScreen()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
}

extension AuthCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnBoarding(coordinator: Coordinator) {
        delegate?.didFinishAuthFlow(coordinator: self)
    }
}
