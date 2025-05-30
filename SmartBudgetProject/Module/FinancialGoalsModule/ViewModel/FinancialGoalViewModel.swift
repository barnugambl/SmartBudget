//
//  FinancialGoalViewmOdel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import Combine

enum ErrorField {
    case name
    case amount
    case date
}

final class FinancialGoalViewModel: FinancialGoalViewModelProtocol {
    private let financialGoalApiService: FinancialGoalAPIServiceProtocol
    private var requestTask: Task<Void, Never>?
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
    @Published private(set) var errorField: ErrorField?
    @Published private(set) var errorMessage: String?
    @Published var financialGoals: [Goal] = []
    
    var cleanAmountString: String {
        amountString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
   
    init(userId: Int, goalId: Int, financilGoaSevice: FinancialGoalAPIServiceProtocol) {
        self.goalId = goalId
        self.userId = userId
        self.financialGoalApiService = financilGoaSevice
    }
    
    func addAmount() {
        guard validateAmount() else { return }
        let goal = GoalRequest(userId: userId, name: name, targetAmount: Int(amountString) ?? 0, deadline: dateString)
        
        Task {
            let responce = await updateFinancialGoal(userId: userId, goalId: goalId, body: goal)
            if let responce {
                successMessage = R.string.localizable.financialGoal_success_added()
                print(responce.message)
            } else {
                errorMessage = R.string.localizable.financialGoal_error_general()
            }
        }
    }
    
    func addGoal() {
        guard validateName(), validateAmount(), validateDate() else { return }
        let goal = GoalRequest(userId: userId, name: name, targetAmount: Int(cleanAmountString) ?? 0,
                               deadline: Date.convertToServerFormat(from: dateString) ?? "")
        Task {
            let responce = await createFinancialGoal(goal: goal)
            if let responce {
                successMessage = R.string.localizable.financialGoal_success_created()
                print(responce.message)
            } else {
                errorMessage = R.string.localizable.financialGoal_error_general()
            }
        }
    }
    
    func resetMessages() {
        self.errorMessage = nil
        self.successMessage = nil
        self.errorField = nil
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
        requestTask = Task {
            do {
                let fetchFinancialGoals = try await financialGoalApiService.getFinancialGoals(userId: userId)
                self.financialGoals = fetchFinancialGoals
                self.isLoading = false
                self.requestTimer?.cancel()
            } catch {
                print("Ошибка при получение целей: \(error)")
                self.requestTimer?.cancel()
            }
            self.isLoading = false
        }
        requestTimer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .prefix(1)
            .sink(receiveValue: { [weak self] _ in
                self?.handleErrorRequestTimeOut()
                self?.requestTask?.cancel()
            })
    }
}

// MARK: Handle error from server
private extension FinancialGoalViewModel {
    func handleErrorRequestTimeOut() {
        isLoading = false
        errorMessage = R.string.localizable.financialGoal_error_timeout()
        print("Время ожидание сервера превышено")
        requestTimer?.cancel()
    }
}

// MARK: Validation
private extension FinancialGoalViewModel {
    func validateAmount() -> Bool {
        guard !amountString.isEmpty else {
            errorMessage = R.string.localizable.financialGoal_error_emptyAmount()
            errorField = .amount
            return false
        }
        
        guard let amount = Int(cleanAmountString), amount > 0 else {
            errorMessage = R.string.localizable.financialGoal_error_zeroAmount()
            errorField = .amount
            return false
        }
        return true
    }
    
    func validateName() -> Bool {
        guard !name.isEmpty else {
            errorMessage = R.string.localizable.financialGoal_error_emptyName()
            errorField = .name
            return false
        }
        return true
    }
    
    func validateDate() -> Bool {
        guard !dateString.isEmpty else {
            errorMessage = R.string.localizable.financialGoal_error_emptyDate()
            errorField = .date
            return false
        }
        return true
    }
}
