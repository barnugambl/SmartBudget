//
//  SetupPersentage.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.06.2025.
//

import Foundation
import Combine
import UIKit

class SetupPersentageViewModel {
    private let userId: Int
    let budgetService: BudgetServiceProtocol
    private let coreDataService = BudgetCoreDataManager.shared
    
    @Published private(set) var errorMessage: String?
    
    init(budgetService: BudgetServiceProtocol, userId: Int) {
        self.budgetService = budgetService
        self.userId = userId
    }
    
    func canAdjustPercentage(for categories: [CategoryDto], name: String, newPercentage: Int) -> Bool {
        let currentTotal = categories.reduce(0) { $0 + $1.persentage }
        let oldValue = categories.first { $0.name == name }?.persentage ?? 0
        let delta = newPercentage - oldValue
        return (currentTotal + delta) <= 100
    }
    
    func isFullPercentage(for categories: [CategoryDto]) -> Bool {
        if categories.reduce(0, { $0 + $1.persentage }) == 100 {
            return true
        } else {
            errorMessage = "Сумма процентов не равна 100"
            return false
        }
    }
    
    func createBudget(income: String, categories: [CategoryDto], completion: @escaping (Bool) -> Void) {
        let incomeInt = Int(income.digitsOnly) ?? 0
        let budgetCategories = categories.map { categoryDto in
            let limit = (incomeInt * categoryDto.persentage) / 100
            return BudgetCategory(name: categoryDto.name, spent: 0, remaining: limit, limit: limit)
        }
        let budget = Budget(income: incomeInt, categories: budgetCategories)
        let requestCategories = categories.map { $0.toRequest() }
        
        Task {
            let responce = try await budgetService.setupBudget(
                budget: BudgetRequest(
                    userId: userId,
                    income: incomeInt,
                    categories: requestCategories
                )
            )
            if responce != nil {
                budgetService.budgetSubject.send(budget)
                do {
                    try coreDataService.saveBudget(income: incomeInt, categories: categories)
                } catch {
                    print(BudgetCoreDataError.saveFailed.localizedDescription)
                }
                completion(true)
            } else {
                errorMessage = R.string.localizable.budgetErrorGeneral()
                completion(false)
            }
        }
    }
    
    func createBudgetCD(income: String, categories: [CategoryDto]) -> BudgetCD {
        let incomeInt = Int32(income.digitsOnly) ?? 0
        let budgetCD = BudgetCD(context: coreDataService.viewContext)
        budgetCD.income = incomeInt
        categories.enumerated().forEach { index, categoryDto in
            let limit = (Int(incomeInt) * categoryDto.persentage) / 100
            
            let budgetCategoryCD = BudgetCategoryCD(context: coreDataService.viewContext)
            budgetCategoryCD.id = Int64(index)
            budgetCategoryCD.name = categoryDto.name
            budgetCategoryCD.persentage = Int32(categoryDto.persentage)
            budgetCategoryCD.limit = Int32(limit)
            budgetCategoryCD.spent = 0
            budgetCategoryCD.remaining = Int32(limit)
            budgetCategoryCD.iconColor = categoryDto.iconColor
            budgetCategoryCD.iconName = categoryDto.iconName
            
            budgetCD.addToBudgetCategory(budgetCategoryCD)
        }
        
        return budgetCD
    }
    
    func resetError() {
        errorMessage = nil
    }
}
