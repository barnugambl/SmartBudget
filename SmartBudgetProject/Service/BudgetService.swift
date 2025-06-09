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
    func fetchTransaction(userId: Int) async throws -> [Transaction]?
    func fetchTransactionsFromFile(userId: Int) async throws -> [Transaction]? 
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
    
    func fetchTransaction(userId: Int) async throws -> [Transaction]? {
        do {
            return try await budgetAPIService.getTransaction(userId: userId)
        } catch {
            print("Не удалось получить транзакции: \(error)")
            return nil
        }
    }
    
    func fetchTransactionsFromFile(userId: Int) async throws -> [Transaction]? {
        do {
            guard let fileURL = Bundle.main.url(forResource: "Trans", withExtension: "json") else {
                print("Файл не найден")
                return nil
            }
            
            let data = try Data(contentsOf: fileURL)
            
            let transactions = try JSONDecoder().decode([Transaction].self, from: data)
            
            return transactions.filter { $0.userId == userId }
        } catch {
            print("Не удалось прочитать файл: \(error)")
            return nil
        }
    }
}
