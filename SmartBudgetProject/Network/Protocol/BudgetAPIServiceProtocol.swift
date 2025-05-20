//
//  BudgetAPIServiceProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

protocol BudgetAPIServiceProtocol {
    func setBudget(userId: Int, income: Int, categories: [Category]) async throws
    func getBudgetStatus(userId: Int) async throws -> BudgetStatus
    func updateBudget(userId: Int, income: Int) async throws
    
}
