//
//  ExpensesViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation

final class ExpensesViewModel {
    var financialGoals: [BudgetCategory] = [
        .init(name: "Транспорт", plannedAmount: 100_000, spentAmount: 90_000),
        .init(name: "Продукты", plannedAmount: 50_000, spentAmount: 20_000),
        .init(name: "Другое", plannedAmount: 10_000, spentAmount: 1000)
        
    ]
}
