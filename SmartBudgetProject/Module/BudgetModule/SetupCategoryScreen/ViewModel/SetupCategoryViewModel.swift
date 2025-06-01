//
//  SetupCategoryViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.06.2025.
//

import Foundation
import Combine
import UIKit

class SetupCategoryViewModel {
    let budgetService: BudgetServiceProtocol
    
    init(budgetService: BudgetServiceProtocol) {
        self.budgetService = budgetService
    }
}
