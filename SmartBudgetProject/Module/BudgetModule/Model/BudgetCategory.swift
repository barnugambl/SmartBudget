//
//  BudgetCategory.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

struct BudgetCategory: Hashable, Codable {
    let name: String
    var spent: Int
    var remaining: Int
    var limit: Int
}
