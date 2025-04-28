//
//  NewPasswordViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import Foundation
import UIKit

class NewPasswordViewController: UIViewController {
    private lazy var newPassView = NewPasswordView()
    private var viewModel: NewPasswordViewModel
    var coordinator: AppCoordinator?

    init(viewModel: NewPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newPassView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        newPassView.didTapContinue = { [weak self] in
            self?.coordinator?.navigationController.popToRootViewController(animated: true)
        }
    }
}
