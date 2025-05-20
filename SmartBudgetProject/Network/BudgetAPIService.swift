//
//  BudgetNetworkService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

final class BudgetAPIService: BudgetAPIServiceProtocol {
    private let client: APIServiceProtocol
    
    init(client: APIServiceProtocol) {
        self.client = client
    }
    
    func setBudget(userId: Int, income: Int, categories: [Category]) async throws {
        let body = BudgetRequest(userId: userId, income: income, categories: categories)
        let _: EmptyResponse = try await client.post(endpoint: setBudgetURL, body: body)
    }
    
    func getBudgetStatus(userId: Int) async throws -> BudgetStatus {
        try await client.get(endpoint: getBudgetStatucURL(userId: userId), parameters: nil)
    }
    
    func updateBudget(userId: Int, income: Int) async throws {
        let body: [String: Int] = ["income": income]
        let _: EmptyResponse = try await client.patch(endpoint: updateBudget(userId: userId), body: body)
    }
}

private extension BudgetAPIService {
    var setBudgetURL: String {
        return "/api/v1/budget"
    }
    
    func getBudgetStatucURL(userId: Int) -> String {
        return "/api/v1/budget/status/\(userId)"
    }
    
    func updateBudget(userId: Int) -> String {
        return "/api/v1/budget/\(userId)"
    }
}
