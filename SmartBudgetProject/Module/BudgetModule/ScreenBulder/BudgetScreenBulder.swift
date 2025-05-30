//
//  BudgetScreenBulder.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

final class BudgetScreenBulder {
    
    private init() {}
    
    static let shared = BudgetScreenBulder()
    
    private let viewModel = BudgetViewModel(userId: 1)
    
    func makeExpensesScreen() -> BudgetViewController {
        return BudgetViewController(viewModel: viewModel)
    }
    
    func makeInitialBudgetScreen() -> InitialBudgetViewController {
        return InitialBudgetViewController(viewModel: viewModel)
    }
    
    func makeSetupPersentScreen(categories: [CategoryDto]) -> SetupPersentViewController {
        return SetupPersentViewController(viewModel: viewModel, categories: categories)
    }
    
    func makeSetupCategoryScreen(category: CategoryDto) -> SetupCategoryViewController {
        return SetupCategoryViewController(viewModel: viewModel, category: category)
    }
}
