//
//  FinancialGoalAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 20.05.2025.
//

import Foundation

protocol FinancialGoalAPIServiceProtocol {
    func createFinancialGoal(userId: Int, goal: GoalRequest) async throws -> Goal?
    func getFinancialGoals(userId: Int) async throws -> [Goal]?
    func updateFinancialGoal(userId: Int, goalId: Int, request: GoalRequest) async throws -> Goal?
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce?
    func updateMoneyFinancialGoal(userId: Int, goalId: Int, body: GoalRequestMoney) async throws -> Goal?
}

final class FinancialGoalAPIService: FinancialGoalAPIServiceProtocol {
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func createFinancialGoal(userId: Int, goal: GoalRequest) async throws -> Goal? {
        try await apiService.post(endpoint: URLConstantGoal.createGoalURL(userId: userId), body: goal)
    }
    
    func getFinancialGoals(userId: Int) async throws -> [Goal]? {
        try await apiService.get(endpoint: URLConstantGoal.getGoalsURL(userId: userId), parameters: nil)
    }
    
    func updateFinancialGoal(userId: Int, goalId: Int, request: GoalRequest) async throws -> Goal? {
        try await apiService.put(endpoint: URLConstantGoal.updateGoalURL(userId: userId, goalId: goalId), body: request)
    }
    
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce? {
        try await apiService.delete(endpoint: URLConstantGoal.deleteGoalURL(userId: userId, goalId: goalId))
    }
    func updateMoneyFinancialGoal(userId: Int, goalId: Int, body: GoalRequestMoney) async throws -> Goal? {
        try await apiService.patch(endpoint: URLConstantGoal.updateMoney(userId: userId, goalId: goalId), body: body)
    }
    
}

