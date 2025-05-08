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
        showSetupCategoryScreen(title: "Mock", iconName: R.image.coins_icon.name, iconColor: .systemOrange)
    }
    
    
    func showSetupCategoryScreen(title: String, iconName: String, iconColor: UIColor) {
        let viewModel = SetupCategoryViewModel()
        let vc = SetupCategoryViewController(viewModel: viewModel, title: title, iconName: iconName, iconColor: iconColor)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
