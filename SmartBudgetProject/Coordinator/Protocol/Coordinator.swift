//
//  CoordinatorProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}

