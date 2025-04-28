//
//  AuthViewConroller.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import Foundation
import UIKit

class LogViewConroller: UIViewController {
    private var logView = LogView()
    private var viewModel: LogViewModel
    weak var coordinator: AppCoordinator?
    
    init(viewModel: LogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = logView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
       
    }
    
    private func setupNavigation() {
        logView.onEvent = { [weak self] event in
            switch event {
            case .didTapRegister:
                self?.coordinator?.showRegScreen()
            case .didTapForgotPassword:
                self?.coordinator?.showPasswordRecoveryScreen()
            case .didTapLogin:
                self?.coordinator?.showMainTabBar()
            case .didTapTId:
                break
            }
        }
    }
}
