//
//  FinancialGoalAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 20.05.2025.
//

import Foundation

final class FinancialGoalAPIService: FinancialGoalAPIServiceProtocol {
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func createFinancialGoal(goal: GoalRequest) async throws -> ServerMessageResponce {
        try await apiService.post(endpoint: createGoalURL, body: goal)
    }
    
    func getFinancialGoals(userId: Int) async throws -> [Goal] {
        try await apiService.get(endpoint: getGoalsURL(userId: userId), parameters: nil)
    }
    
    func updateFinancialGoal(userId: Int, goalId: Int, request: GoalRequest) async throws -> ServerMessageResponce {
        try await apiService.put(endpoint: updateGoalURL(userId: userId, goalId: goalId), body: request)
    }
    
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce {
        try await apiService.delete(endpoint: deleteGoalURL(userId: userId, goalId: goalId))
    }
}

// MARK: URL
private extension FinancialGoalAPIService {
    var createGoalURL: String {
        return "/goals"
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

// MARK: Mock
extension FinancialGoalAPIService {
    func getMockFinancialGoal(userId: Int) async throws -> [Goal] {
        guard let url = Bundle(for: type(of: self)).url(forResource: "financialgoal", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw NSError(domain: "Tests", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить JSON файл"])
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Goal].self, from: data)
    }
}
