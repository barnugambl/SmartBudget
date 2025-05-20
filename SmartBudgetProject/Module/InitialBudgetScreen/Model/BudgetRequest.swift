//
//  BudgetRequest.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

struct BudgetRequest: Encodable {
    let userId: Int
    let income: Int
    let categories: [Category]
}
