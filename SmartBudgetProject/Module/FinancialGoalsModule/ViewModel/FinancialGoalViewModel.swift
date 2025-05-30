//
//  FinancialGoalViewmOdel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import Combine

final class FinancialGoalViewModel: FinancialGoalViewModelProtocol {
    private let financialGoalApiService: FinancialGoalAPIServiceProtocol
    private var requestTimer: AnyCancellable?
    let userId: Int
    let goalId: Int

    // Input
    @Published var name: String = ""
    @Published var amountString: String = ""
    @Published var dateString: String = ""
    @Published var isLoading: Bool = false
    
    // Output
    @Published private(set) var successMessage: String?
    @Published private(set) var errorMessage: String?
    @Published var financialGoals: [Goal] = []
    
    var cleanAmountString: String {
        amountString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
   
    init(userId: Int, goalId: Int, financilGoaSevice: FinancialGoalAPIServiceProtocol) {
        self.goalId = goalId
        self.userId = userId
        self.financialGoalApiService = financilGoaSevice
        resetMessages()
    }
    
    func addAmount() {
        guard validateAmount() else { return }
        let goal = GoalRequest(userId: userId, name: name, targetAmount: Int(amountString) ?? 0, deadline: dateString)
        
        Task {
            let responce = await updateFinancialGoal(userId: userId, goalId: goalId, body: goal)
            if responce != nil {
                successMessage = "Сумма успешна добавлена"
            } else {
                errorMessage = "Упс произошла ошибка, попробуйте еще раз"
            }
        }
    }
    
    func addGoal() {
        guard validateName() else { return }
        guard validateAmount() else { return }
        guard validateDate() else { return }
    
        let goal = GoalRequest(userId: userId, name: name, targetAmount: Int(cleanAmountString) ?? 0,
                               deadline: Date.convertToServerFormat(from: dateString) ?? "")
        Task {
            let responce = await createFinancialGoal(goal: goal)
            if responce != nil {
                successMessage = "Цель успешна создана"
            } else {
                errorMessage = "Упс произошла ошибка, попробуйте еще раз"
            }
        }
    }
    
    func resetMessages() {
        errorMessage = nil
        successMessage = nil
    }
}

// MARK: API request
extension FinancialGoalViewModel {
    func createFinancialGoal(goal: GoalRequest) async -> ServerMessageResponce? {
        do {
            return try await financialGoalApiService.createFinancialGoal(goal: goal)
        } catch {
            print("Не удалось создать цель: \(error)")
            return nil
        }
    }
    
    func updateFinancialGoal(userId: Int, goalId: Int, body: GoalRequest) async -> ServerMessageResponce? {
        do {
            return try await financialGoalApiService.updateFinancialGoal(userId: userId, goalId: goalId, request: body)
        } catch {
            print("Не удалось обновить цель: \(error)")
            return nil
        }
    }
    
    func fetchFinancialGoals() {
        isLoading = true
        
        requestTimer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.handleErrorRequestTimeOut()
            })
        
        Task {
            do {
                let fetchFinancialGoals = try await financialGoalApiService.getFinancialGoals(userId: userId)
                self.financialGoals = fetchFinancialGoals
                self.isLoading = false
                self.requestTimer?.cancel()
            } catch {
                self.isLoading = false
                self.requestTimer?.cancel()
                print("Не удалось получить цели: \(error)")
            }
        }
    }
}

// MARK: Handle error from server
private extension FinancialGoalViewModel {
    func handleErrorRequestTimeOut() {
        isLoading = false
        errorMessage = "Упс что то пошло не так, попробуйте позже"
        print("Время ожидание сервера превышено")
        requestTimer?.cancel()
    }
}

// MARK: Validation
private extension FinancialGoalViewModel {
    func validateAmount() -> Bool {
        guard !amountString.isEmpty else {
            errorMessage = "Сумма не может быть пустой"
            return false
        }
        return true
    }
    
    func validateName() -> Bool {
        guard !name.isEmpty else {
            errorMessage = "Название цели не может быть пустым"
            return false
        }
        return true
    }
    
    func validateDate() -> Bool {
        guard !dateString.isEmpty else {
            errorMessage = "Дата не может быть пустой"
            return false
        }
        return true
    }
}
