//
//  FinancialGoal.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation

enum FinancialGoalStatus: String, Codable {
    case completed = "COMPLETED"
    case failed = "FAILED"
    case inProgress = "IN_PROGRESS"
}

struct Goal: Codable, Hashable {
    let id: Int
    let name: String
    let targetAmount: Int
    let savedAmount: Int
    let recommendedMonthlySaving: Int
    let deadline: String
    let status: FinancialGoalStatus
    
    func toRequset(userId: Int) -> GoalRequest {
        return GoalRequest(userId: userId, name: name, targetAmount: targetAmount, deadline: deadline)
    }
}
