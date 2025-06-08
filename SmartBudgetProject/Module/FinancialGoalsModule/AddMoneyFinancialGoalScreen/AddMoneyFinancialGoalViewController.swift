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
    private let viewModel: FinancialGoalViewModel
    private let addMoneyFinancialGoalView = AddMoneyFinancialGoalView()
    private var nameGoal: String
    private var cancellables: Set<AnyCancellable> = .init()
    weak var coordinator: FinancialGoalCoordinator?
 
    init(viewModel: FinancialGoalViewModel, nameGoal: String) {
        self.viewModel = viewModel
        self.nameGoal = nameGoal
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
        setupName()
        setupNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.resetMessages()
    }
    
    private func setupName() {
        addMoneyFinancialGoalView.titleLabel.text = nameGoal
        navigationItem.titleView = addMoneyFinancialGoalView.titleLabel
    }
    
    private func setupNavigation() {
        addMoneyFinancialGoalView.clickOnConfirmButton = { [weak self] in
            self?.viewModel.addAmount()
        }
    }
    
    private func bindingViewModel() {
        addMoneyFinancialGoalView.addAmountTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.amountString,
                    on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.addMoneyFinancialGoalView.setErrorMessage(message)
            }
            .store(in: &cancellables)
    }
}
