//
//  ExpensesViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation
import Combine
import UIKit

final class BudgetViewModel {    
    private let userId: Int
    let budgetService: BudgetServiceProtocol
    private let cancellable: Set<AnyCancellable> = .init()
        
    init(userId: Int, budgetService: BudgetServiceProtocol) {
        self.userId = userId
        self.budgetService = budgetService
    }
}

