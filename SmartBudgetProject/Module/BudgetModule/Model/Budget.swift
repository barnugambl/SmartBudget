//
//  Budget.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

struct Budget: Codable {
    var income: Int
    var categories: [BudgetCategory]
}
