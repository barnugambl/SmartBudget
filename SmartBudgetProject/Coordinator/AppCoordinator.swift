//
//  AppCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAuthFlow()
    }
    
    func showMainFlow() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController, profileDelegate: self)
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishAuthFlow(coordinator: AuthCoordinator) {
        childDidFinish(coordinator)
        showMainFlow()
    }
}

extension AppCoordinator: ProfileCoordinatorDelegate {
    func startOnboarding(coordinator: Coordinator) {
        if let mainTabBarCoordinator = childCoordinators.first(where: { $0 is MainTabBarCoordinator }) {
            childDidFinish(mainTabBarCoordinator)
        }
        
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
    }
    
    func logout(coordinator: Coordinator) {
        if let mainTabBarCoordinator = childCoordinators.first(where: { $0 is MainTabBarCoordinator }) {
            childDidFinish(mainTabBarCoordinator)
        }
        showAuthFlow()
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnBoarding(coordinator: any Coordinator) {
        childDidFinish(coordinator)
        showMainFlow()
    }
}
