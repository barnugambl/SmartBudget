//
//  BudgetAPIServiceProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

protocol BudgetAPIServiceProtocol {
    func setupBudget(budget: BudgetRequest) async throws -> ServerMessageResponce?
    func getBudget(userId: Int) async throws -> Budget
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce?
}
