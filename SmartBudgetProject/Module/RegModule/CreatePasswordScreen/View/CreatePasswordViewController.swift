//
//  CreatePasswordViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 03.05.2025.
//

import Foundation
import UIKit

final class CreatePasswordViewController: UIViewController {
    private var createPasswordView = CreatePasswordView()
    private var viewModel = CreatePasswordViewModel()
    weak var coordinator: AuthCoordinator?
    
    init(viewModel: CreatePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = createPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        createPasswordView.didTapContinue = { [weak self] in
            self?.coordinator?.startOnBoardingFlow()
        }
    }
}
