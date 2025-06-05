//
//  ProfileScreenBulder.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.06.2025.
//

import Foundation

final class ProfileScreenBulder {
    
    private init() { }
    
    static let shared = ProfileScreenBulder()
    
    private let budgetService = BudgetService.shared
    
    func makeExpensesScreen() -> ExpensesViewController {
        let viewModel = ExpensenViewModel(budgetService: budgetService, userId: 1)
        return ExpensesViewController(viewModel: viewModel)
    }
    
}
