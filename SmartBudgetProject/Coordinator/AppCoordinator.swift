//
//  AppCoordinator.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    func start() {
        showMainTabBar()
    }
    
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func showMainTabBar() {
        let tabBarController = CustomTabBarController()
        
        let profileVM = ProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileVM)
        profileVC.coordinator = self
        
        let navProfileVC = UINavigationController(rootViewController: profileVC)
        
        tabBarController.viewControllers = [navProfileVC]
        tabBarController.setupTabBar()
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }

        
    func showProfileScreen() {
        let viewModel = ProfileViewModel()
        let vc = ProfileViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditProfileScreen() {
        let viewModel = EditProfileViewModel()
        let vc = EditProfileViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
