//
//  AddFinancialGoalViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import UIKit

class AddFinancialGoalViewController: UIViewController {
    private var addFinancialGoalView = AddFinancialGoalView()
    private var viewModel: FinancialGoalViewModel
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
        addFinancialGoalView.dateTextField.addTarget(self, action: #selector(setupDatePicker),
                                                     for: .editingDidBegin)
        
        addFinancialGoalView.onClickButton = { [weak self] in
            self?.addGoals()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addGoals() {
        let name = addFinancialGoalView.nameGoalTextField.text ?? ""
        let sum = addFinancialGoalView.sumGoalTextField.text ?? ""
//        let dateString = addFinancialGoalView.dateTextField.text ?? ""

        let financialGoal = FinancialGoal(
            id: UUID(),
            name: name,
            sum: sum,
            date: Date(),
            executionProcess: .progress
        )

        viewModel.addGoasl(goal: financialGoal)
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
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            self?.addFinancialGoalView.dateTextField.text = formatter.string(from: selectedDate)
        }
        present(datePickerVC, animated: true)
    }
}
