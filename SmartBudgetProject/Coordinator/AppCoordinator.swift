//
//  AppCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    func start() {
        showPasswordRecoveryScreen()
    }
    
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func showPasswordRecoveryScreen() {
        let viewModel = PasswordRecoveryViewModel()
        let vc = PasswordRecoveryViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCheckNumberPhoneScreen(type: ConfirmationFlow) {
        let viewModel = CheckNumberPhoneViewModel()
        let vc = CheckNumberPhonelViewController(viewModel: viewModel, type: type)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNewPasswordScreen() {
        let viewModel = CreateNewPasswordViewModel()
        let vc = CreateNewPasswordViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
