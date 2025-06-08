//
//  Budget.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation
import CoreData

struct Budget: Codable {
    var income: Int
    var categories: [BudgetCategory]
}

extension Budget {
    func toBudgetCD(context: NSManagedObjectContext) -> BudgetCD {
        let budgetCD = BudgetCD(context: context)
        budgetCD.income = Int32(income)
        
        let categoriesCD = categories.map { category in
            category.toBudgetCategoryCD(context: context, budget: budgetCD)
        }
        
        budgetCD.categoriesArray = categoriesCD
        return budgetCD
    }
}
