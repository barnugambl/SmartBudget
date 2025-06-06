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
            .sink { [weak self] budget in
                guard let self else { return }
                self.income = budget.income
            }
            .store(in: &cancellable)
    }
    
    func budgetCategoriesToCategoryDto(budget: Budget) -> [CategoryDto] {
        let defaultCategories = UserDefaultsService.shared.categoryDto
        
        return budget.categories.map { budgetCategory in
            if let defaultCategory = defaultCategories?.first(where: { $0.name == budgetCategory.name }) {
                return CategoryDto(
                    name: budgetCategory.name,
                    iconName: defaultCategory.iconName,
                    iconColor: defaultCategory.iconColor,
                    persentage: budget.income > 0 ? Int((Double(budgetCategory.limit) / Double(budget.income)) * 100) : 0
                )
            } else {
                return CategoryDto(
                    name: budgetCategory.name,
                    iconName: R.image.other_icon.name,
                    iconColor: "#8E8E93",
                    persentage: budget.income > 0 ? Int((Double(budgetCategory.limit) / Double(budget.income)) * 100) : 0
                )
            }
        }
    }
        
}
