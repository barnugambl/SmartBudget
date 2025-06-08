//
//  BudgetCategory.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation
import CoreData

struct BudgetCategory: Hashable, Codable {
    let name: String
    var spent: Int
    var remaining: Int
    var limit: Int
}

extension BudgetCategory {
    func toBudgetCategoryCD(context: NSManagedObjectContext, budget: BudgetCD? = nil) -> BudgetCategoryCD {
        let categoryCD = BudgetCategoryCD(context: context)
        categoryCD.name = name
        categoryCD.spent = Int32(spent)
        categoryCD.remaining = Int32(remaining)
        categoryCD.limit = Int32(limit)
        categoryCD.budget = budget
        
        return categoryCD
    }
}
