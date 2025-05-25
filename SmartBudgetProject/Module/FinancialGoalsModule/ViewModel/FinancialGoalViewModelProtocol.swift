//
//  FinancialGoalViewModelProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 20.05.2025.
//

import Foundation
import Combine

protocol FinancialGoalViewModelProtocol {
    var name: String { get set }
    var amountString: String { get set }
    var dateString: String { get set }
    var isLoading: Bool { get set }
    
    var successMessage: String? { get }
    var errorMessage: String? { get }
    var financialGoals: [Goal] { get }
    var cleanAmountString: String { get }
    
    init(userId: Int, goalId: Int, financilGoaSevice: FinancialGoalAPIServiceProtocol)
    
    func addAmount()
    func addGoal()
    func resetMessages()
    func fetchFinancialGoals()
}
