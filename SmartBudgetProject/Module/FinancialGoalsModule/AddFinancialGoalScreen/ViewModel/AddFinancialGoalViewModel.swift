//
//  AddFinancialGoalViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.06.2025.
//

import Foundation

enum ErrorField {
    case name
    case amount
    case date
}

class AddFinancialGoalViewModel {
    let financialGoalService: FinancialGoalServiceProtocol
    private let userId: Int
    
    // Input
    @Published var name: String = ""
    @Published var amountString: String = ""
    @Published var dateString: String = ""
    
    // Output
    @Published private(set) var errorMessageField: String?
    @Published private(set) var errorMessage: String?
    @Published private(set) var errorField: ErrorField?
        
    private var cleanAmountInt: Int {
        Int(amountString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
    }
    
    private var dateServerFormat: String {
        Date.convertToServerFormat(from: dateString) ?? ""
    }
    
    init(userId: Int, financialGoalService: FinancialGoalServiceProtocol) {
        self.financialGoalService = financialGoalService
        self.userId = userId
    }
    
    func addGoal(completion: @escaping (Bool) -> Void) {
        resetMessages()
        guard validateName(), validateAmount(), validateDate() else {
            completion(false)
            return
        }
        
        let goal = Goal(id: 20,
                        name: name,
                        targetAmount: cleanAmountInt,
                        savedAmount: 0,
                        recommendedMonthlySaving: 0,
                        deadline: dateServerFormat,
                        status: .inProgress)
        Task {
            do {
                if (try await financialGoalService.createFinancialGoal(goal: goal.toRequset(userId: userId))) != nil {
                    financialGoalService.successMessageSubject.send(R.string.localizable.goalCreateSuccess())
                    financialGoalService.addGoalSubject.send(goal)
                    completion(true)
                } else {
                    errorMessage = R.string.localizable.goalGeneralError()
                    errorMessageField = nil
                    completion(false)
                }
            } catch {
                print("Не удалось добавить цель: \(error)")
                errorMessageField = nil
                completion(false)
            }
        }
    }
    
    private func resetMessages() {
        errorMessage = nil
        errorMessageField = nil
        errorField = nil
    }
}

// MARK: Validation
private extension AddFinancialGoalViewModel {
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
            errorMessageField = R.string.localizable.goalZeroAmount()
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
}
