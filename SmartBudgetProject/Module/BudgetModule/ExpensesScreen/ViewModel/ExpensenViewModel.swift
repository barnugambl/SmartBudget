//
//  ExpensenViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.06.2025.
//

import Foundation
import Combine

final class ExpensenViewModel {
    private let userId: Int
    let budgetService: BudgetServiceProtocol
    private var categories: [CategoryDto]?
    private var income: Int?
    private var cancellable: Set<AnyCancellable> = .init()

    @Published private(set) var errorMessage: String?
    
    init(budgetService: BudgetServiceProtocol, userId: Int) {
        self.budgetService = budgetService
        self.userId = userId
    }
    
    func obtainBudget() {
        budgetService.budgetSubject
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] budget, colors in
                guard let self else { return }
                self.income = budget.income
            }
            .store(in: &cancellable)
    }
    
}
