//
//  FinancialGoalAPIServiceProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 20.05.2025.
//

import Foundation

protocol FinancialGoalAPIServiceProtocol {
    func createFinancialGoal(goal: GoalRequest) async throws -> ServerMessageResponce
    func getFinancialGoals(userId: Int) async throws -> [Goal]
    func updateFinancialGoal(userId: Int, goalId: Int, request: GoalRequest) async throws -> ServerMessageResponce
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce
    func getMockFinancialGoal(userId: Int) async throws -> [Goal]
}
