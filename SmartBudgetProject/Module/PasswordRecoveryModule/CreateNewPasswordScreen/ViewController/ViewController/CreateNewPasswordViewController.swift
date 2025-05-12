//
//  NewPasswordViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import Foundation
import UIKit



class CreateNewPasswordViewController: UIViewController {
    private lazy var newPasswordView = CreateNewPasswordView()
    private var viewModel: CreateNewPasswordViewModel
    weak var coordinator: AuthCoordinator?

    init(viewModel: CreateNewPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        newPasswordView.didTapContinue = { [weak self] in
            self?.coordinator?.navigationController.popToRootViewController(animated: true)
            print("create")
        }
    }
}
