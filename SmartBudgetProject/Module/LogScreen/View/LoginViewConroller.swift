//
//  AuthViewConroller.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import Foundation
import UIKit
import Combine

final class LoginViewConroller: UIViewController {
    private var logView = LoginView()
    private var viewModel: LoginViewModel
    private var cancellable: Set<AnyCancellable> = .init()
    weak var coordinator: AuthCoordinator?
    
    init(viewModel: LoginViewModel) {
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
        bindingViewModel()
    }
    
    private func bindingViewModel() {
        logView.phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber,
                    on: viewModel)
            .store(in: &cancellable)
        
        logView.passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password,
                    on: viewModel)
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                self.logView.hideErrorLabel()
                CustomToastView.showErrorToast(on: self.logView, message: message)
            }
            .store(in: &cancellable)

        viewModel.$errorMessageField
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                guard let self else { return }
                if let errorField = viewModel.errorField {
                    self.logView.setTextLabelError(message)
                    switch errorField {
                    case .phoneNumber:
                        self.logView.updateErrorLabelPosition(for: self.logView.phoneNumberTextField)
                    case .password:
                        self.logView.updateErrorLabelPosition(for: self.logView.passwordTextField)
                    }
                } else {
                    self.logView.hideErrorLabel()
                }
            }
            .store(in: &cancellable)
    }
    
    private func setupNavigation() {
        logView.didTapLogin = { [weak self] in
            guard let self else { return }
            self.viewModel.isLogin { isLogin in
                if isLogin {
                    DispatchQueue.main.async {
                        self.coordinator?.startOnBoardingFlow()
                    }
                }
            }
            
        }
    }
}
