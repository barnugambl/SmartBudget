//
//  Transaction.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 09.06.2025.
//

import Foundation

struct Transaction: Codable, Hashable {
    let userId: Int
    let date: String
    let description: String
    let amount: String
    let category: String
}
