//
//  GoalRequest.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 21.05.2025.
//

import Foundation

struct GoalRequest: Encodable {
    let userId: Int
    let name: String
    let targetAmount: Int
    let deadline: String
}
