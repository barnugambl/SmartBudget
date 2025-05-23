//
//  CustomTabBarController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit
import SnapKit

final class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSeparatorView()
    }
    
    func setupTabBar() {
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.tintColor = .systemBlue
        
        viewControllers?[0].tabBarItem = UITabBarItem(title: "Расходы", image: UIImage(systemName: "creditcard.fill"), tag: 0)
        viewControllers?[1].tabBarItem = UITabBarItem(title: "Цели", image: UIImage(systemName: "target"), tag: 1)
        viewControllers?[2].tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), tag: 2)
    }
    
    private func setupSeparatorView() {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.lightGray
        separatorLine.backgroundColor = .systemGray5
        view.addSubview(separatorLine)
        
        separatorLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(tabBar)
            make.height.equalTo(1)
        }
        
    }
}
