//
//  FinancialGoalScreenBulder.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.06.2025.
//

import Foundation

class FinancialGoalScreenBulder {
    let financialGoalService = FinancialGoalService.shared
    
    private init() {}
    
    static let shared = FinancialGoalScreenBulder()
    
    func makeFinancialGoalScreen() -> FinancialGoalsViewController {
        let viewModel = FinancialGoalViewModel(userId: 1, financialGoalService: financialGoalService)
        return FinancialGoalsViewController(viewModel: viewModel)
    }
    
    func makeAddFinancialGoalScreen() -> AddFinancialGoalViewController {
        let viewModel = AddFinancialGoalViewModel(userId: 1, financialGoalService: financialGoalService)
        return AddFinancialGoalViewController(viewModel: viewModel)
    }
    
    func makeEditFinancialGoalScreen(goal: Goal) -> EditFinancialGoalViewController {
        let viewModel = EditFinancialGoalViewModel(userId: 1, goal: goal, financialGoalService: financialGoalService)
        return EditFinancialGoalViewController(viewModel: viewModel)
    }
    
    func makeAddMoneyFinancialGoalScreen(goal: Goal) -> AddMoneyFinancialGoalViewController {
        let viewModel = AddMoneyFinancialGoalViewModel(userId: 1, goal: goal, financialGoalService: financialGoalService)
        return AddMoneyFinancialGoalViewController(viewModel: viewModel)
    }
}
