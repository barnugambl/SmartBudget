//
//  AppCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        let viewModel = LogViewModel()
        let logVC = LogViewConroller(viewModel: viewModel)
        logVC.coordinator = self
        navigationController.pushViewController(logVC, animated: true)
    }
    
    func showLogScreen() {
        let viewModel = LogViewModel()
        let vc = LogViewConroller(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        let viewModel = LogViewModel()
        let vc = LogViewConroller(viewModel: viewModel)
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showRegScreen() {
        let viewModel = RegViewModel()
        let vc = RegViewConroller(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCreatePasswordScreen() {
        let viewModel = CreatePasswordViewModel()
        let vc = CreatePasswordViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
