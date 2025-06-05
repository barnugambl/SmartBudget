//
//  BudgetAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

final class BudgetAPIService: BudgetAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func setupBudget(budget: BudgetRequest) async throws -> ServerMessageResponce? {
        try await apiService.post(endpoint: URLConstansBudget.setupBudgetURL, body: budget)
    }
    
    func getBudget(userId: Int) async throws -> Budget {
        try await apiService.get(endpoint: URLConstansBudget.getBudgetURL(userId: userId), parameters: nil)
    }
    
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce? {
        try await apiService.patch(endpoint: URLConstansBudget.updateBudgetURL(userId: userId), body: ["income": income])
    }
}
