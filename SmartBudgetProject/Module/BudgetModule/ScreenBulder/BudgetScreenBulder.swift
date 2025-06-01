//
//  BudgetScreenBulder.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

final class BudgetScreenBulder {
    private let budgetService: BudgetServiceProtocol
    
    init(budgetService: BudgetServiceProtocol) {
        self.budgetService = budgetService
    }
    
    func makeBudgetScreen() -> BudgetViewController {
        let viewModel = BudgetViewModel(userId: 1, budgetService: budgetService)
        return BudgetViewController(viewModel: viewModel)
    }
    
    func makeInitialBudgetScreen() -> InitialBudgetViewController {
        let viewModel = InitialBudgetViewModel(budgetService: budgetService)
        return InitialBudgetViewController(viewModel: viewModel)
    }
    
    func makeSetupPersentScreen() -> SetupPersentViewController {
        let viewModel = SetupPersentageViewModel(budgetService: budgetService, userId: 1)
        return SetupPersentViewController(viewModel: viewModel)
    }
    
    func makeSetupCategoryScreen(category: CategoryDto) -> SetupCategoryViewController {
        let viewModel = SetupCategoryViewModel(budgetService: budgetService)
        return SetupCategoryViewController(viewModel: viewModel, category: category)
    }
}
