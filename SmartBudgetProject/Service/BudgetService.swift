//
//  BudgetService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 31.05.2025.
//

import Foundation
import Combine
import UIKit

protocol BudgetServiceProtocol {
    var initialBudgetSubject: CurrentValueSubject<(String, [CategoryDto]), Never> { get }
    var budgetSubject: CurrentValueSubject<(Budget, [UIColor])?, Never> { get }
    var updateColorSubject: CurrentValueSubject<(UIColor, String)?, Never> { get }
    
    func fetchBudget(userId: Int) async throws -> Budget?
    func setupBudget(budget: BudgetRequest) async throws -> ServerMessageResponce?
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce?
}

class BudgetService: BudgetServiceProtocol {
    private let budgetAPIService: BudgetAPIServiceProtocol
    let initialBudgetSubject = CurrentValueSubject<(String, [CategoryDto]), Never>(("", CategoryDto.defaultCategories()))
    let budgetSubject = CurrentValueSubject<(Budget, [UIColor])?, Never>(nil)
    var updateColorSubject = CurrentValueSubject<(UIColor, String)?, Never>(nil)
    
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
            throw error
        }
    }
    
    func setupBudget(budget: BudgetRequest) async throws -> ServerMessageResponce? {
        do {
            return try await budgetAPIService.setupBudget(budget: budget)
        } catch {
            print("Установить бюджет не удалось: \(error)")
            throw error
        }
    }
    
    func updateBudget(userId: Int, income: Int) async throws -> ServerMessageResponce? {
        do {
            return try await budgetAPIService.updateBudget(userId: userId, income: income)
        } catch {
            print("Не удалось обновить бюджет: \(error)")
            throw error
        }
    }
}
