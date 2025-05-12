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

class ProfileCoordinator: Coordinator {
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
        
    private let moduleBulder = ModuleBulder()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProfileFlow()
    }
    
    func showProfileFlow() {
        let profileVC = moduleBulder.makeProfileScreen()
        profileVC.coordinator = self
        navigationController.setViewControllers([profileVC], animated: false)
    }
    
    func showEdtiProfleFlow() {
        let editProfileVC = moduleBulder.makeEditProfileScreen()
        editProfileVC.coordinator = self
        navigationController.pushViewController(editProfileVC, animated: true)
    }
    
    func logout() {
        delegate?.logout(coordinator: self)
    }
}
