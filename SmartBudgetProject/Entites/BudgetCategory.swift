//
//  BudgetCategory.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 28.04.2025.
//

import Foundation

struct BudgetCategory: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let name: String
    let plannedAmount: Int
    var spentAmount: Int
    
    
    var remainingAmount: Int {
        return plannedAmount - spentAmount
    }
}
