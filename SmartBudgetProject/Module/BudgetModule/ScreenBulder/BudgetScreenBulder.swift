//
//  BudgetScreenBulder.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

final class BudgetScreenBulder {
    private let budgetService = BudgetService.shared
    private var currentUserId: Int {
        Int(UserCoreDataManager.shared.getCurrentUser()?.id ?? 0)
    }
    private init() {}
    
    static let shared = BudgetScreenBulder()
    
    func makeBudgetScreen() -> BudgetViewController {
        let viewModel = BudgetViewModel(userId: currentUserId, budgetService: budgetService)
        return BudgetViewController(viewModel: viewModel)
        
    }
    
    func makeInitialBudgetScreen() -> InitialBudgetViewController {
        let viewModel = InitialBudgetViewModel(budgetService: budgetService)
        return InitialBudgetViewController(viewModel: viewModel)
    }
    
    func makeSetupPersentScreen() -> SetupPersentageViewController {
        let viewModel = SetupPersentageViewModel(budgetService: budgetService, userId: currentUserId)
        return SetupPersentageViewController(viewModel: viewModel)
    }
    
    func makeSetupCategoryScreen(category: CategoryDto) -> SetupCategoryViewController {
        let viewModel = SetupCategoryViewModel(budgetService: budgetService)
        return SetupCategoryViewController(viewModel: viewModel, category: category)
    }
    
    func makeTranstactionScreen(name: String) -> TransactionViewController {
        let viewModel = TransactionViewModel(budgetService: budgetService)
        return TransactionViewController(viewModel: viewModel, name: name)
    }
}
