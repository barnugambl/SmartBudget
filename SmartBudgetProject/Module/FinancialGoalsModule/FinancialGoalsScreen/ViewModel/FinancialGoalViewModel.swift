//
//  FinancialGoalViewmOdel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import Combine

class FinancialGoalViewModel {
    @Published var financialGoals: [FinancialGoal] = [
        .init(id: UUID(), name: "Цель 1", sum: "2000", date: Date(), executionProcess: .completed),
        .init(id: UUID(), name: "Цель 2", sum: "3000", date: Date(), executionProcess: .failed),
        .init(id: UUID(), name: "Цель 3", sum: "4000", date: Date(), executionProcess: .progress),
        .init(id: UUID(), name: "Цель 4", sum: "5000", date: Date(), executionProcess: .progress)
    ]
    
    func addGoasl(goal: FinancialGoal) {
        financialGoals.append(goal)
        print("✅ Goal added, total count: \(goal)")
    }
}
