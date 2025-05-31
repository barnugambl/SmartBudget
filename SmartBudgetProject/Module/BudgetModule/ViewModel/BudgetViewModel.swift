//
//  ExpensesViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation
import Combine
import UIKit

final class BudgetViewModel: BudgetViewModelProtocol {    
    private let userId: Int
    private var budget: Budget?
    private let budgetAPIService = BudgetAPIService(apiService: ApiService())
    private var cancellables: Set<AnyCancellable> = .init()
    let budgetSubject = CurrentValueSubject<(Budget, [UIColor])?, Never>(nil)
    let colorCategoryUpdate = PassthroughSubject<(UIColor, String), Never>()
    
    // Input
    @Published var incomeString: String = ""
    @Published var isIncomeValid: Bool = false
    
    // Output
    @Published private(set) var errorMessage: String?
    
    init(userId: Int) {
        self.userId = userId
        setupInputValidation()
    }
    
    func createBudget(categories: [CategoryDto]) {
        let incomeInt = Int(incomeString.digitsOnly) ?? 0
        let budgetCategories = categories.map { categoryDto in
            let limit = (incomeInt * categoryDto.persentage) / 100
            return BudgetCategory(name: categoryDto.name, spent: 0, remaining: limit, limit: limit)
        }
        let budget = Budget(income: incomeInt, categories: budgetCategories)
        let colors = categories.map({ $0.iconColor })
        
        Task {
            let requestCategory = categories.map({ $0.toRequset() })
            let responce = await setupBudget(budget: BudgetRequest(userId: userId, income: incomeInt, categories: requestCategory))
            if responce == nil {
                errorMessage = R.string.localizable.budgetErrorGeneral()
            }
        }
        budgetSubject.send((budget, colors))
    }
    
    func canAdjustPercentage(for categories: [CategoryDto], name: String, newPercentage: Int) -> Bool {
        let currentTotal = categories.reduce(0) { $0 + $1.persentage }
        let oldValue = categories.first { $0.name == name }?.persentage ?? 0
        let delta = newPercentage - oldValue
        return (currentTotal + delta) <= 100
    }
    
    func updateCategoryColor(_ color: UIColor, _ name: String) {
        colorCategoryUpdate.send((color, name))
    }
    
    func resetError() {
        errorMessage = nil
    }
}

// MARK: API request
extension BudgetViewModel {
    func fetchBudget() {
        Task {
            do {
               budget = try await budgetAPIService.getBudget(userId: userId)
            } catch {
                print("Не удалось получить бюджет: \(error)")
            }
        }
    }
    
    func setupBudget(budget: BudgetRequest) async -> ServerMessageResponce? {
        do {
            return try await budgetAPIService.setupBudget(budget: budget)
        } catch {
            print("Установить бюджет не удалось: \(error)")
            return nil
        }
    }
    
    func updateBudget(income: Int) async -> ServerMessageResponce? {
        do {
            return try await budgetAPIService.updateBudget(userId: userId, income: income)
        } catch {
            print("Не удалось обновить бюджет: \(error)")
            return nil
        }
    }
}

// MARK: Validation
extension BudgetViewModel {
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
