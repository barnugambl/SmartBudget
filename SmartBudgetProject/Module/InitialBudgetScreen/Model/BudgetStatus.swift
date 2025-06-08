//
//  BudgetStatus.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

struct BudgetStatus: Codable {
    let income: Int
    let categories: [Category]
}
