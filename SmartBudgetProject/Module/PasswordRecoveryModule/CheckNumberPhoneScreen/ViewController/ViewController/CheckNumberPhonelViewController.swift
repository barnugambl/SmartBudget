//
//  CheckEmailViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import Foundation
import UIKit

enum ConfirmationFlow {
    case registration
    case passwordRecovery
}

class CheckNumberPhonelViewController: UIViewController {
    private var type: ConfirmationFlow
    private var viewModel: CheckNumberPhoneViewModel
    private var checNumberPhoneView = CheckNumberPhoneView()
    weak var coordinator: AuthCoordinator?
    
    init(viewModel: CheckNumberPhoneViewModel, type: ConfirmationFlow) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = checNumberPhoneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        checNumberPhoneView.onEvent = { [weak self] event in
            switch event {
            case .didTapContinue:
                self?.handleContinue()
            case .didTapHaventEmail:
                break
            }
        }
    }
    
    private func handleContinue() {
        switch type {
        case .registration:
            self.coordinator?.showCreatePasswordFlow()
        case .passwordRecovery:
            self.coordinator?.showCreateNewPasswordFlow()
        }
    }
}
