//
//  BudgetRequest.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

struct BudgetRequest: Codable {
    let userId: Int
    let income: Int
    let categories: [Category]
}
