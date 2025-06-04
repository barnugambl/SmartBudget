//
//  AddMoneyFinancialGoalViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.06.2025.
//

import Foundation

class AddMoneyFinancialGoalViewModel {
    let financialGoalService: FinancialGoalServiceProtocol
    private let userId: Int
    let goal: Goal
    
    // Input
    @Published var amountString: String = ""
    
    // Output
    @Published private(set) var errorMessageField: String?
    @Published private(set) var errorMessage: String?
    
    init(userId: Int, goal: Goal, financialGoalService: FinancialGoalServiceProtocol) {
        self.financialGoalService = financialGoalService
        self.userId = userId
        self.goal = goal
    }
    
    private var cleanAmountInt: Int {
        Int(amountString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
    }
    
    private func resetError() {
        errorMessageField = nil
        errorMessage = nil
    }
    
    func addAmount(completion: @escaping (Bool) -> Void) {
        resetError()
        guard validateAmount() else {
            completion(false)
            return
        }
        let savedAmount = min((goal.savedAmount + cleanAmountInt), goal.targetAmount)
        let status = checkStatus(goal: goal)
        let updateGoal = Goal(id: goal.id,
                              name: goal.name,
                              targetAmount: goal.targetAmount,
                              savedAmount: savedAmount,
                              recommendedMonthlySaving: goal.recommendedMonthlySaving,
                              deadline: goal.deadline,
                              status: status)
        Task {
            do {
                if (try await financialGoalService.updateFinancialGoal(userId: userId, goalId: goal.id,
                                                                       body: updateGoal.toRequset(userId: userId))) != nil {
                    financialGoalService.successMessageSubject.send(R.string.localizable.goalAddMoneySuccess())
                    financialGoalService.updateGoalSubject.send(updateGoal)
                    completion(true)
                } else {
                    errorMessage = R.string.localizable.goalGeneralError()
                    errorMessageField = nil
                    completion(false)
                }
            } catch {
                print("Ошибка при добавление суммы к целе: \(error)")
                errorMessageField = nil
                completion(false)
            }
        }
    }
}

// MARK: Validation
private extension AddMoneyFinancialGoalViewModel {
    func validateAmount() -> Bool {
        guard !amountString.isEmpty else {
            errorMessageField = R.string.localizable.goalEmptyAmount()
            return false
        }
        
        guard Int(amountString.digitsOnly) ?? 0 > 0 else {
            errorMessageField = R.string.localizable.goalZeroAmount()
            return false
        }
        
        return true
    }
    
    func checkStatus(goal: Goal) -> FinancialGoalStatus {
        var status = goal.status
        let newSavedAmount = goal.savedAmount + cleanAmountInt
        if newSavedAmount >= goal.targetAmount {
            status = .completed
        }
        return status
    }
}
