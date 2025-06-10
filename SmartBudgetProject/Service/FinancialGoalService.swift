//
//  FinancialGoalService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.06.2025.
//

import Foundation
import Combine

protocol FinancialGoalServiceProtocol {
    var successMessageSubject: CurrentValueSubject<String?, Never> { get }
    var updateGoalSubject: PassthroughSubject<Goal, Never> { get }
    var addGoalSubject: PassthroughSubject<Goal, Never> { get }
    
    func createFinancialGoal(userId: Int, goal: GoalRequest) async throws -> Goal?
    func updateFinancialGoal(userId: Int, goalId: Int, body: GoalRequest) async throws -> Goal?
    func fetchFinancialGoals(userId: Int) async throws -> [Goal]?
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce?
    func updateMoneyGoal(userId: Int, goalId: Int, body: GoalRequestMoney) async throws -> Goal?
}

class FinancialGoalService: FinancialGoalServiceProtocol {
    let financialGoalAPIService: FinancialGoalAPIServiceProtocol
    var successMessageSubject = CurrentValueSubject<String?, Never>(nil)
    var updateGoalSubject = PassthroughSubject<Goal, Never>()
    var addGoalSubject = PassthroughSubject<Goal, Never>()
        
    init(financialGoalAPIService: FinancialGoalAPIServiceProtocol) {
        self.financialGoalAPIService = financialGoalAPIService
    }
}

// MARK: API
extension FinancialGoalService {
    func createFinancialGoal(userId: Int, goal: GoalRequest) async throws -> Goal? {
        do {
            return try await financialGoalAPIService.createFinancialGoal(userId: userId, goal: goal)
        } catch {
            print("Не удалось создать цель: \(error)")
            return nil
        }
    }
    
    func updateFinancialGoal(userId: Int, goalId: Int, body: GoalRequest) async throws -> Goal? {
        do {
            return try await financialGoalAPIService.updateFinancialGoal(userId: userId, goalId: goalId, request: body)
        } catch {
            print("Не удалось обновить цель: \(error)")
            return nil
        }
    }
    
    func fetchFinancialGoals(userId: Int) async throws -> [Goal]? {
        do {
            return try await financialGoalAPIService.getFinancialGoals(userId: userId)
        } catch {
            print("Не удалось получить цели: \(error)")
            return nil
        }
    }
    
    func deleteFinancialGoal(userId: Int, goalId: Int) async throws -> ServerMessageResponce? {
        do {
            return try await financialGoalAPIService.deleteFinancialGoal(userId: userId, goalId: goalId)
        } catch {
            print("Не удалось удалить цель: \(error)")
            return nil
        }
    }
    
    func updateMoneyGoal(userId: Int, goalId: Int, body: GoalRequestMoney) async throws -> Goal? {
        do {
            return try await financialGoalAPIService.updateMoneyFinancialGoal(userId: userId, goalId: goalId, body: body)
        } catch {
            print("Не удалось обновить цель: \(error)")
            return nil
        }
    }
}
