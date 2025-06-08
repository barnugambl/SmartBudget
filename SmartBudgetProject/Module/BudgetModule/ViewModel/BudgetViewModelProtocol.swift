//
//  ExpensenViewModelProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.05.2025.
//

import Combine
import UIKit

protocol BudgetViewModelProtocol {
    var incomeString: String { get set }
    var isIncomeValid: Bool { get set }
    var errorMessage: String? { get }

    var budgetSubject: CurrentValueSubject<(Budget, [UIColor])?, Never> { get }
    var colorCategoryUpdate: PassthroughSubject<(UIColor, String), Never> { get }

    func createBudget(categories: [CategoryDto])
    func updateCategoryColor(_ color: UIColor, _ name: String)
    func resetError()
    func fetchBudget()
    func validateOnSumbit() -> Bool
}
