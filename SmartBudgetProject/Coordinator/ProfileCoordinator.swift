//
//  ProfileCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func logout(coordinator: Coordinator)
    func startOnboarding(coordinator: Coordinator)
}

final class ProfileCoordinator: Coordinator {
    weak var delegate: ProfileCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
        
    private let profileBulder = ProfileScreenBulder.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProfileFlow()
    }
    
    func showExpensenFlow() {
        let expensesVC = profileBulder.makeExpensesScreen()
        expensesVC.coordinator = self
        expensesVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(expensesVC, animated: true)
    }
    
    func showProfileFlow() {
        let profileVC = profileBulder.makeProfileScreen()
        profileVC.coordinator = self
        navigationController.setViewControllers([profileVC], animated: false)
    }
    
    func showEditProfleFlow() {
        let editProfileVC = profileBulder.makeEditProfileScreen()
        editProfileVC.coordinator = self
        editProfileVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(editProfileVC, animated: true)
    }
    
    func showOnboardingFlow() {
        delegate?.startOnboarding(coordinator: self)
    }
        
    func logout() {
        delegate?.logout(coordinator: self)
    }
}
