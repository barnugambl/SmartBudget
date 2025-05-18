//
//  AuthViewConroller.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import Foundation
import UIKit

final class LogViewConroller: UIViewController {
    private var logView = LogView()
    private var viewModel: LogViewModel
    weak var coordinator: AuthCoordinator?
    
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
            guard let self = self, let coordinator = self.coordinator else { return }
            switch event {
            case .didTapRegister:
                coordinator.showRegisterFlow()
            case .didTapForgotPassword:
                coordinator.showPasswordRecoveryFlow()
            case .didTapLogin:
                coordinator.delegate?.didFinishAuthFlow(coordinator: coordinator)
            case .didTapTId:
                break
            }
        }
    }
}
