//
//  InitialBudgetViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation

final class InitialBudgetViewModel {
    private let budgetService = BudgetAPIService(client: ApiService())
     
    func setBudget(userId: Int, income: Int, categories: [Category]) {
        Task {
            do {
                try await budgetService.setBudget(userId: userId, income: income, categories: categories)
            } catch {
                print("Не удалось устновить бюджет \(error)")
            }
        }
    }
}
