//
//  FinancialGoal.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import CoreData

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

extension Goal {
    func toFinancialGoalCD(context: NSManagedObjectContext) -> FinancialGoalCD {
        let goalCD = FinancialGoalCD(context: context)
        goalCD.id = Int64(id)
        goalCD.name = name
        goalCD.targetAmount = Int32(targetAmount)
        goalCD.savedAmount = Int32(savedAmount)
        goalCD.recommendedMonthlySaving = Int32(recommendedMonthlySaving)
        goalCD.deadline = deadline
        goalCD.status = status.rawValue
        return goalCD
    }
    
    func updateFinancialGoalCD(_ goalCD: FinancialGoalCD) {
        goalCD.name = name
        goalCD.targetAmount = Int32(targetAmount)
        goalCD.savedAmount = Int32(savedAmount)
        goalCD.recommendedMonthlySaving = Int32(recommendedMonthlySaving)
        goalCD.deadline = deadline
        goalCD.status = status.rawValue
    }
}
