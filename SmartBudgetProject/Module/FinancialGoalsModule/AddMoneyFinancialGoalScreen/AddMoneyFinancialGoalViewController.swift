//
//  AddMoneyFinancialGoals.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit
import Foundation

final class AddMoneyFinancialGoalViewController: UIViewController {
    private var viewModel: FinancialGoalViewModel
    private var addMoneyFinancialGoalView = AddMoneyFinancialGoalView()
    weak var coordinator: FinancialGoalCoordinator?
    private var nameGoal: String
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupName()
    }
    
    private func setupName() {
        addMoneyFinancialGoalView.titleLabel.text = nameGoal
        navigationItem.titleView = addMoneyFinancialGoalView.titleLabel
    }
}
