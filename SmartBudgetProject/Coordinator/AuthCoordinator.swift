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
    private let moduleBulder = ModuleBulder()
    private let budgetBulder: BudgetScreenBulder
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, budgetBulder: BudgetScreenBulder) {
        self.navigationController = navigationController
        self.budgetBulder = budgetBulder
    }
    
    func start() {
        showLoginFlow()
        
    }
    
    func startOnBoardingFlow() {
        let onBoardingCoordinator = OnboardingCoordinator(navigationController: navigationController, budgetBulder: budgetBulder)
        onBoardingCoordinator.delegate = self
        childCoordinators.append(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
    
    func showLoginFlow() {
        let loginVC = moduleBulder.makeLoginScreen()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func showPasswordRecoveryFlow() {
        let passwordRecoveryVC = moduleBulder.makePasswordRecoveryScreen()
        passwordRecoveryVC.coordinator = self
        navigationController.pushViewController(passwordRecoveryVC, animated: true)
    }
    
    func showCheckNumberFlow(type: ConfirmationFlow) {
        let checkNumberVC = moduleBulder.makeCheckPhoneScreen(type: type)
        checkNumberVC.coordinator = self
        navigationController.pushViewController(checkNumberVC, animated: true)
    }
    
    func showCreateNewPasswordFlow() {
        let createNewPasswordVC = moduleBulder.makeCreateNewPasswordScreen()
        createNewPasswordVC.coordinator = self
        navigationController.pushViewController(createNewPasswordVC, animated: true)
    }
    
    func showCreatePasswordFlow() {
        let createPasswordVC = moduleBulder.makeCreatePasswordScreen()
        createPasswordVC.coordinator = self
        navigationController.pushViewController(createPasswordVC, animated: true)
    }
    
    func showRegisterFlow() {
        let registerVC = moduleBulder.makeRegScreen()
        registerVC.coordinator = self
        navigationController.setViewControllers([registerVC], animated: true)
    }
}

extension AuthCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnBoarding(coordinator: Coordinator) {
        delegate?.didFinishAuthFlow(coordinator: self)
    }
}

