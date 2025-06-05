//
//  ProfileCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 12.05.2025.
//

import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func logout(coordinator: Coordinator)
}

final class ProfileCoordinator: Coordinator {
    weak var delegate: ProfileCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
        
    private let moduleBulder = ModuleBulder()
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
        navigationController.pushViewController(expensesVC, animated: true)
    }
    
    func showProfileFlow() {
        let profileVC = moduleBulder.makeProfileScreen()
        profileVC.coordinator = self
        navigationController.setViewControllers([profileVC], animated: false)
    }
    
    func showEditProfleFlow() {
        let editProfileVC = moduleBulder.makeEditProfileScreen()
        editProfileVC.coordinator = self
        navigationController.pushViewController(editProfileVC, animated: true)
    }
    
    func logout() {
        delegate?.logout(coordinator: self)
    }
}
