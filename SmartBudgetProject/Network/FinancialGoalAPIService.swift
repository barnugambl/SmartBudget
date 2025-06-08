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
}

final class FinancialGoalAPIService: FinancialGoalAPIServiceProtocol {    
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func createFinancialGoal(userId: Int, goal: GoalRequest) async throws -> Goal? {
        try await apiService.post(endpoint: createGoalURL(userId: userId), body: goal)
    }
    
    func getFinancialGoals(userId: Int) async throws -> [Goal]? {
        try await apiService.get(endpoint: getGoalsURL(userId: userId), parameters: nil)
    }
    
    func updateFinancialGoal(userId: Int, goalId: Int, request: GoalRequest) async throws -> Goal? {
        try await apiService.put(endpoint: updateGoalURL(userId: userId, goalId: goalId), body: request)
    }
    
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce? {
        try await apiService.delete(endpoint: deleteGoalURL(userId: userId, goalId: goalId))
    }
}

// MARK: URL
private extension FinancialGoalAPIService {
    func createGoalURL(userId: Int) -> String {
        return "/goals/\(userId)"
    }
    
    func getGoalsURL(userId: Int) -> String {
        return "/goals/\(userId)"
    }
    
    func updateGoalURL(userId: Int, goalId: Int) -> String {
        return "/goals/\(userId)/\(goalId)"
    }
    
    func deleteGoalURL(userId: Int, goalId: Int) -> String {
        return "/goals/\(userId)/\(goalId)"
    }
}
