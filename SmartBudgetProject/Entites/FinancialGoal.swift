//
//  FinancialGoal.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation

enum GoalExecutionProcess {
    case completed
    case failed
    case progress
}

struct FinancialGoal: Identifiable, Hashable {
    var id: UUID
    var name: String
    var sum: String
    var date: Date
    var executionProcess: GoalExecutionProcess
}
