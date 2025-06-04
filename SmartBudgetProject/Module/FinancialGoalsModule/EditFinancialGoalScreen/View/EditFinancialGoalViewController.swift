//
//  EditFinancialGoalViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 02.06.2025.
//

import Foundation
import UIKit
import Combine

class EditFinancialGoalViewController: UIViewController {
    private let formatter = DateFormatter()
    private let editFinancialGoalView = EditFinancialGoalView()
    private let viewModel: EditFinancialGoalViewModel
    weak var coordinator: FinancialGoalCoordinator?
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(viewModel: EditFinancialGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = editFinancialGoalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupPlaceHolderTextFiedls()
        setupDateTextField()
        bindingViewModel()
        setupNavigation()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = editFinancialGoalView.titleLabel
    }
    
    private func setupNavigation() {
        editFinancialGoalView.onClickButton = { [weak self]  in
            guard let self else { return }
            viewModel.editGoal { isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func setupPlaceHolderTextFiedls() {
        editFinancialGoalView.nameGoalTextField.text = viewModel.goal.name
        viewModel.name = viewModel.goal.name
        
        editFinancialGoalView.amountGoalTextField.text = "\(viewModel.goal.targetAmount) ₽"
        viewModel.amountString = "\(viewModel.goal.targetAmount)"
        
        editFinancialGoalView.dateTextField.text = viewModel.goal.deadline
        viewModel.dateString = viewModel.goal.deadline
    }
    
    private func setupDateTextField() {
        editFinancialGoalView.dateTextField.addTarget(self, action: #selector(setupDatePicker),
                                                     for: .editingDidBegin)
    }
        
    private func bindingViewModel() {
        editFinancialGoalView.nameGoalTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.name,
                    on: viewModel)
            .store(in: &cancellable)
        
        editFinancialGoalView.amountGoalTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.amountString,
                    on: viewModel)
            .store(in: &cancellable)
        
        editFinancialGoalView.dateTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.dateString,
                    on: viewModel)
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] message in
                guard let self else { return }
                self.editFinancialGoalView.hideErrorLabel()
                CustomToastView.showErrorToast(on: self.editFinancialGoalView, message: message)
            }
            .store(in: &cancellable)
        
        viewModel.$errorMessageField
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                guard let self else { return }
                if let errorField = viewModel.errorField {
                    self.editFinancialGoalView.setTextLabelError(message)
                    switch errorField {
                    case .name:
                        self.editFinancialGoalView.updateErrorLabelPosition(for: self.editFinancialGoalView.nameGoalTextField)
                    case .amount:
                        self.editFinancialGoalView.updateErrorLabelPosition(for: self.editFinancialGoalView.amountGoalTextField)
                    case .date:
                        self.editFinancialGoalView.updateErrorLabelPosition(for: self.editFinancialGoalView.dateTextField)
                    }
                } else {
                    self.editFinancialGoalView.hideErrorLabel()
                }
            }
            .store(in: &cancellable)
    }
    
    @objc
    private func setupDatePicker() {
        editFinancialGoalView.dateTextField.resignFirstResponder()
        let datePickerVC = DatePicker()
        datePickerVC.modalPresentationStyle = .pageSheet

        if let sheet = datePickerVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        datePickerVC.onDateSelected = { [weak self] selectedDate in
            self?.formatter.dateStyle = .long
            self?.editFinancialGoalView.dateTextField.text = self?.formatter.string(from: selectedDate)
            self?.editFinancialGoalView.dateTextField.notifyTextChanged()

        }
        present(datePickerVC, animated: true)
    }
}
