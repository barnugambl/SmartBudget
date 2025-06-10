//
//  TransactionViewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 09.06.2025.
//

import Foundation
import Combine

final class TransactionViewModel {
    let budgetService: BudgetServiceProtocol
    
    var transaction: [Transaction] = []
    let userId = Int(UserCoreDataManager.shared.getCurrentUser()?.id ?? 0)
    private let coreDataManager = BudgetCoreDataManager.shared
    
    @Published private(set) var errorMessage: String?
    
    init(budgetService: BudgetServiceProtocol) {
        self.budgetService = budgetService
        fetchTransactions()
    }

    func fetchTransactions() {
        errorMessage = nil
        Task {
            let responce = try await budgetService.fetchTransactionsFromFile(userId: userId)
            if let responce {
                transaction = responce
                budgetService.updateBudgetForTransaction.send(responce)
            } else {
                errorMessage = R.string.localizable.budgetErrorGeneral()
            }
        }
    }
    
    func getIconName(_ name: String) -> String {
        return coreDataManager.fetchCategoryIcon(for: name)
    }
    
    func getIconColorByName(_ name: String) -> String {
        return coreDataManager.fetchCategoryColor(for: name)
    }
}
