//
//  AddMoneyFinancialGoals.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import UIKit
import Foundation

class AddMoneyFinancialGoalViewController: UIViewController {
    private var viewModel: AddMoneyFinancialGoalViewModel
    private var addMoneyFinancialGoalView = AddMoneyFinancialGoalView()
    weak var coordinator: AppCoordinator?
    private var name: String
    
    init(viewModel: AddMoneyFinancialGoalViewModel, name: String) {
        self.viewModel = viewModel
        self.name = name
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
        addMoneyFinancialGoalView.titleLabel.text = name
    }
}
