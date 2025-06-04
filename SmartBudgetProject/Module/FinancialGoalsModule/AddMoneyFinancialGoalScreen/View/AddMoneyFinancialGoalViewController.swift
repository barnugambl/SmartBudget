//
//  AddMoneyFinancialGoals.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit
import Foundation
import Combine

final class AddMoneyFinancialGoalViewController: UIViewController {
    private let viewModel: AddMoneyFinancialGoalViewModel
    private let addMoneyFinancialGoalView = AddMoneyFinancialGoalView()
    private var cancellables: Set<AnyCancellable> = .init()
    weak var coordinator: FinancialGoalCoordinator?
 
    init(viewModel: AddMoneyFinancialGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addMoneyFinancialGoalView
        bindingViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.addMoneyFinancialGoalView.titleLabel.text = viewModel.goal.name
        self.navigationItem.titleView = addMoneyFinancialGoalView.titleLabel
    }
    
    private func setupNavigation() {
        addMoneyFinancialGoalView.clickOnConfirmButton = { [weak self] in
            guard let self else { return }
            self.viewModel.addAmount { isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func bindingViewModel() {
        addMoneyFinancialGoalView.addAmountTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.amountString,
                    on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$errorMessageField
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.addMoneyFinancialGoalView.setErrorMessage(message)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                guard let self else { return }
                self.addMoneyFinancialGoalView.hideError()
                CustomToastView.showErrorToast(on: self.addMoneyFinancialGoalView, message: message)
            }
            .store(in: &cancellables)
    }
}
