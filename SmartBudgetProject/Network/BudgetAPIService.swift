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
        try await apiService.post(endpoint: URLConstans.setupBudgetURL, body: budget)
    }
    
    func getBudget(userId: Int) async throws -> Budget {
        try await apiService.get(endpoint: URLConstans.getBudgetURL(userId: userId), parameters: nil)
    }
    
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce? {
        try await apiService.patch(endpoint: URLConstans.updateBudgetURL(userId: userId), body: ["income": income])
    }
}
