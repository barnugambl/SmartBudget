//
//  EditFinancialGoalViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 02.06.2025.
//

import Foundation

class EditFinancialGoalViewModel {
    let financialGoalService: FinancialGoalServiceProtocol
    private let userId: Int
    let goal: Goal
    
    // Input
    @Published var name: String = ""
    @Published var amountString: String = ""
    @Published var dateString: String = ""
    
    // Output
    @Published private(set) var errorMessageField: String?
    @Published private(set) var errorMessage: String?
    @Published private(set) var errorField: ErrorField?
    
    init(userId: Int, goal: Goal, financialGoalService: FinancialGoalServiceProtocol) {
        self.userId = userId
        self.goal = goal
        self.financialGoalService = financialGoalService
    }
    
    private var cleanAmountInt: Int {
        Int(amountString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
    }
    
    func editGoal(completion: @escaping (Bool) -> Void) {
        resetMessages()
        guard hasChanges() else {
            errorMessage = R.string.localizable.goalNoChanges()
            completion(false)
            return
            
        }
        guard validateName(), validateAmount(), validateDate() else {
            completion(false)
            return
        }
        
        let updateGoal = Goal(id: goal.id,
                              name: name,
                              targetAmount: cleanAmountInt,
                              savedAmount: goal.savedAmount,
                              recommendedMonthlySaving: goal.recommendedMonthlySaving,
                              deadline: dateString,
                              status: goal.status)
        Task {
            do {
                if (try await financialGoalService.updateFinancialGoal(userId: userId, goalId: updateGoal.id,
                                                                       body: updateGoal.toRequset(userId: userId))) != nil {
                    financialGoalService.successMessageSubject.send(R.string.localizable.goalUpdateSuccess())
                    financialGoalService.updateGoalSubject.send(updateGoal)
                    completion(true)
                } else {
                    errorMessage = R.string.localizable.goalGeneralError()
                    errorMessageField = nil
                    completion(false)
                }
            } catch {
                print("Ошибка при изменение цели: \(error)")
                errorMessageField = nil
                completion(false)
            }
        }
    }
    
    func resetMessages() {
        errorMessage = nil
        errorMessageField = nil
        errorField = nil
    }
}

// MARK: Validation
private extension EditFinancialGoalViewModel {
    func validateAmount() -> Bool {
        guard !amountString.isEmpty else {
            errorMessageField = R.string.localizable.goalEmptyAmount()
            errorField = .amount
            return false
        }
        
        guard Int(amountString.digitsOnly) ?? 0 > 0 else {
            errorMessageField = R.string.localizable.goalZeroAmount()
            errorField = .amount
            return false
        }
        
        return true
    }
    
    func validateName() -> Bool {
        guard !name.isEmpty else {
            errorMessageField = R.string.localizable.goalEmptyName()
            errorField = .name
            return false
        }
        return true
    }
    
    func validateDate() -> Bool {
        guard !dateString.isEmpty else {
            errorMessageField = R.string.localizable.goalEmptyDate()
            errorField = .date
            return false
        }
        return true
    }
    
    func hasChanges() -> Bool {
        return name != goal.name ||
        cleanAmountInt != goal.targetAmount ||
        dateString != goal.deadline
    }
}
