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
    
    private let budgetBulder = BudgetScreenBulder(
        budgetService: BudgetService(budgetAPIService: BudgetAPIService(apiService: ApiService())))
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAuthFlow()
    }
    
    func showMainFlow() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController, profileDelegate: self,
                                                          budgetBulder: budgetBulder)
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, budgetBulder: budgetBulder)
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
    func logout(coordinator: Coordinator) {
        if let mainTabBarCoordinator = childCoordinators.first(where: { $0 is MainTabBarCoordinator }) {
            childDidFinish(mainTabBarCoordinator)
        }
        showAuthFlow()
    }
}

