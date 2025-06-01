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
    
    func createBudget(income: String, categories: [CategoryDto]) {
        let incomeInt = Int(income.digitsOnly) ?? 0
        let budgetCategories = categories.map { categoryDto in
            let limit = (incomeInt * categoryDto.persentage) / 100
            return BudgetCategory(name: categoryDto.name, spent: 0, remaining: limit, limit: limit)
        }
        let budget = Budget(income: incomeInt, categories: budgetCategories)
        let colors = categories.map({ $0.iconColor })
        
        budgetService.budgetSubject.send((budget, colors))
        
        Task {
            let requestCategory = categories.map({ $0.toRequset() })
            let responce = try await budgetService.setupBudget(budget: BudgetRequest(userId: userId, income: incomeInt, categories: requestCategory))
            if responce == nil {
                errorMessage = R.string.localizable.budgetErrorGeneral()
            }
        }
    }
}
