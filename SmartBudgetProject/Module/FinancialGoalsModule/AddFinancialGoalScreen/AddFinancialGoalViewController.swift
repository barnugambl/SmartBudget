//
//  AddFinancialGoalViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import UIKit
import Combine

final class AddFinancialGoalViewController: UIViewController {
    private let formatter = DateFormatter()
    private var addFinancialGoalView = AddFinancialGoalView()
    private var viewModel: FinancialGoalViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    weak var coordinator: FinancialGoalCoordinator?

    init(viewModel: FinancialGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addFinancialGoalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        setupNavigationBar()
        setupDateTextField()
        setupNavigation()
    }
    
    private func setupNavigation() {
        addFinancialGoalView.onClickButton = { [weak self] in
            self?.viewModel.addGoal()
            
        }
    }
    
    private func setupDateTextField() {
        addFinancialGoalView.dateTextField.addTarget(self, action: #selector(setupDatePicker),
                                                     for: .editingDidBegin)
    }
        
    private func setupNavigationBar() {
        navigationItem.titleView = addFinancialGoalView.titleLabel
    }
    
    private func bindingViewModel() {
        addFinancialGoalView.nameGoalTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.name,
                    on: viewModel)
            .store(in: &cancellables)
        
        addFinancialGoalView.amountGoalTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.amountString,
                    on: viewModel)
            .store(in: &cancellables)
        
        addFinancialGoalView.dateTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.dateString,
                    on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                guard let self else { return }
                if let errorField = viewModel.errorField {
                    self.addFinancialGoalView.setTextLabelError(message)
                    switch errorField {
                    case .name:
                        self.addFinancialGoalView.updateErrorLabelPosition(for: self.addFinancialGoalView.nameGoalTextField)
                    case .amount:
                        self.addFinancialGoalView.updateErrorLabelPosition(for: self.addFinancialGoalView.amountGoalTextField)
                    case .date:
                        self.addFinancialGoalView.updateErrorLabelPosition(for: self.addFinancialGoalView.dateTextField)
                    }
                }
            }
            .store(in: &cancellables)
    }

    @objc
    private func setupDatePicker() {
        addFinancialGoalView.dateTextField.resignFirstResponder()
        let datePickerVC = DatePicker()
        datePickerVC.modalPresentationStyle = .pageSheet

        if let sheet = datePickerVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        datePickerVC.onDateSelected = { [weak self] selectedDate in
            self?.formatter.dateStyle = .long
            self?.addFinancialGoalView.dateTextField.text = self?.formatter.string(from: selectedDate)
            self?.addFinancialGoalView.dateTextField.notifyTextChanged()

        }
        present(datePickerVC, animated: true)
    }
}
