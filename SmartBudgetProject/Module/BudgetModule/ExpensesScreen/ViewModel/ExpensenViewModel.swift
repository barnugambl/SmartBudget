//
//  ExpensenViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.06.2025.
//

import Foundation
import Combine

final class ExpensenViewModel {
    private let userId: Int
    let budgetService: BudgetServiceProtocol
    var categories: [CategoryDto] = []
    private var income: Int?
    private var cancellable: Set<AnyCancellable> = .init()
    private let coreDataManager = BudgetCoreDataManager.shared
    
    @Published private(set) var errorMessage: String?
    
    init(budgetService: BudgetServiceProtocol, userId: Int) {
        self.budgetService = budgetService
        self.userId = userId
        self.categories = initCategories()
    }
    
    func initCategories() -> [CategoryDto] {
        let budget = getBudget()
        guard let budget else { return [] }
        print(budget)
        return budget.categories.map({ budgetCategory in
            return CategoryDto(
                name: budgetCategory.name,
                iconName: getIconName(budgetCategory.name),
                iconColor: getIconColorByName(budgetCategory.name),
                persentage: Int(calculatePercentage(limit: budgetCategory.limit, totalIncome: budget.income)))
        })
    }
    
    func getIncomeString() -> String {
        guard let budgetIncome = getBudget()?.income else { return "" }
        return String(budgetIncome)
    }
    
    private func calculatePercentage(limit: Int, totalIncome: Int) -> Double {
        guard totalIncome != 0 else { return 0 }
        return (Double(limit) / Double(totalIncome)) * 100
    }
        
    private func getBudget() -> Budget? {
        do {
            guard let budgetCD = try coreDataManager.fetchCurrentBudget() else { return nil }
            let categories = budgetCD.categories.map(
                { budgetCategoryCD in
                    return BudgetCategory(
                        name: budgetCategoryCD.name ?? "",
                        spent: Int(budgetCategoryCD.spent),
                        remaining: Int(budgetCategoryCD.remaining),
                        limit: Int(budgetCategoryCD.limit))
                })
            return Budget(income: Int(budgetCD.income), categories: categories)
        } catch {
            print(BudgetCoreDataError.fetchFailed)
            return nil
        }
    }
    
    private func getIconName(_ name: String) -> String {
        return coreDataManager.fetchCategoryIcon(for: name)
    }
    private func getIconColorByName(_ name: String) -> String {
        return coreDataManager.fetchCategoryColor(for: name)
    }
}
