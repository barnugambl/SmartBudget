//
//  BudgetService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 31.05.2025.
//

import Foundation
import Combine

protocol BudgetServiceProtocol {
    var initialBudgetSubject: CurrentValueSubject<(String, [CategoryDto]), Never> { get }
    var budgetSubject: CurrentValueSubject<(Budget)?, Never> { get }
    var updateColorSubject: CurrentValueSubject<(String, String)?, Never> { get }
    
    func fetchBudget(userId: Int) async throws -> Budget?
    func setupBudget(budget: BudgetRequest) async throws -> Budget?
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce?
    func mockFetchBudget() async throws -> Budget?
}

class BudgetService: BudgetServiceProtocol {
    private let budgetAPIService: BudgetAPIServiceProtocol
    let initialBudgetSubject = CurrentValueSubject<(String, [CategoryDto]), Never>(("", CategoryDto.defaultCategories()))
    let budgetSubject = CurrentValueSubject<(Budget)?, Never>(nil)
    var updateColorSubject = CurrentValueSubject<(String, String)?, Never>(nil)
    
    private init(budgetAPIService: BudgetAPIServiceProtocol) {
        self.budgetAPIService = budgetAPIService
    }
    
    static let shared = BudgetService(budgetAPIService: BudgetAPIService(apiService: ApiService()))
}

// MARK: API
extension BudgetService {
    func fetchBudget(userId: Int) async throws -> Budget? {
        do {
            return try await budgetAPIService.getBudget(userId: userId)
        } catch {
            print("Не удалось получить бюджет")
            return nil
        }
    }
    
    func setupBudget(budget: BudgetRequest) async throws -> Budget? {
        do {
            return try await budgetAPIService.setupBudget(budget: budget)
        } catch {
            print("Установить бюджет не удалось: \(error)")
            return nil
        }
    }
    
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce? {
        do {
            return try await budgetAPIService.updateBudget(userId: userId, income: income)
        } catch {
            print("Не удалось обновить бюджет: \(error)")
            return nil
        }
    }
    func mockFetchBudget() async throws -> Budget? {
        guard let url = Bundle.main.url(forResource: "budget", withExtension: "json") else {
            print("Mock JSON file not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            let budget = try decoder.decode(Budget.self, from: data)
            
            return budget
        } catch {
            print("Error decoding mock budget: \(error)")
            return nil
        }
    }
    
}
