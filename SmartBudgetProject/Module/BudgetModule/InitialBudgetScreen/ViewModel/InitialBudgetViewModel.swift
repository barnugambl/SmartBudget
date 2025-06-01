//
//  InitialViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 31.05.2025.
//

import Foundation
import Combine
import UIKit

class InitialBudgetViewModel {
    let colorCategoryUpdate = PassthroughSubject<(UIColor, String), Never>()
    private var cancellables: Set<AnyCancellable> = .init()
    let budgetService: BudgetServiceProtocol

    @Published private(set) var errorMessage: String?
    @Published var incomeString: String = ""
    @Published var isIncomeValid: Bool = false
    
    init(budgetService: BudgetServiceProtocol) {
        self.budgetService = budgetService
    }
}

// MARK: Validation
extension InitialBudgetViewModel {
    func validateOnSumbit() -> Bool {
        isIncomeValid = true
        return validateAmount()
    }
    
    private func validateAmount() -> Bool {
        guard isIncomeValid else { return true }
        let cleanIncome = incomeString.digitsOnly
        if cleanIncome.isEmpty {
            errorMessage = R.string.localizable.budgetErrorEmpty()
            return false
        }
        
        if let income = Int(cleanIncome), income == 0 {
            errorMessage = R.string.localizable.budgetErrorZero()
            return false
        }
        errorMessage = nil
        return true
    }
    
    private func setupInputValidation() {
         $incomeString
             .sink { [weak self] _ in
                 self?.validateInput()
             }
             .store(in: &cancellables)
     }
    
    private func validateInput() {
           let cleanIncome = incomeString.digitsOnly
           
           if cleanIncome.isEmpty {
               errorMessage = nil
               return
           }
           
           if let income = Int(cleanIncome), income == 0 {
               errorMessage = R.string.localizable.budgetErrorZero()
           } else {
               errorMessage = nil
           }
       }
}
