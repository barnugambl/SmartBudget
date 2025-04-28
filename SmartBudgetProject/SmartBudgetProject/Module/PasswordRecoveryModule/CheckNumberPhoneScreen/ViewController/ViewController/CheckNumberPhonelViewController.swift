//
//  CheckEmailViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.04.2025.
//

import Foundation
import UIKit

class CheckNumberPhonelViewController: UIViewController {
    private var viewModel: CheckNumberPhoneViewModel
    private var checNumberPhoneView = CheckNumberPhoneView()
    var coordinator: AppCoordinator?
    
    init(viewModel: CheckNumberPhoneViewModel) {
        self.viewModel = viewModel
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
                self?.coordinator?.showNewPasswordScreen()
            case .didTapHaventEmail:
                break
            }
        }
    }
}
