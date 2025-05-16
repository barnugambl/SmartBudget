//
//  PasswordRecoveryViewConroller.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import Foundation
import UIKit

final class PasswordRecoveryViewController: UIViewController {
    private var viewModel: PasswordRecoveryViewModel
    private var passRecView = PasswordRecoveryView()
    weak var coordinator: AuthCoordinator?
    
    init(viewModel: PasswordRecoveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = passRecView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        passRecView.completion = { [weak self] in
            self?.coordinator?.showCheckNumberFlow(type: .passwordRecovery)
        }
    }
}
