//
//  BudgetAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

protocol BudgetAPIServiceProtocol {
    func setupBudget(budget: BudgetRequest) async throws -> Budget?
    func getBudget(userId: Int) async throws -> Budget?
    func getTransaction(userId: Int) async throws -> [Transaction]
}

final class BudgetAPIService: BudgetAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func setupBudget(budget: BudgetRequest) async throws -> Budget? {
        try await apiService.post(endpoint: URLConstansBudget.setupBudgetURL, body: budget)
    }
    
    func getBudget(userId: Int) async throws -> Budget? {
        try await apiService.get(endpoint: URLConstansBudget.getBudgetURL(userId: userId), parameters: nil)
    }
    
    func getTransaction(userId: Int) async throws -> [Transaction] {
        try await apiService.get(endpoint: URLTransactionConstans.getTransactionURL(userId: userId), parameters: nil)
    }
    
}
