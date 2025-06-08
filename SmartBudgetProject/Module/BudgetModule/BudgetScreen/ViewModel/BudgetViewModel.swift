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
    let budgetService: BudgetServiceProtocol
    private var requestTimer: AnyCancellable?
    private var requestTask: Task<Void, Never>?
    private let coreDataService = BudgetCoreDataManager.shared
    
    let userId: Int
    
    @Published var budget: Budget?
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    
    // Output
    @Published private(set) var errorMessage: String?
    var finishLoading: (() -> Void)?
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(userId: Int, budgetService: BudgetServiceProtocol) {
        self.userId = userId
        self.budgetService = budgetService
    }
    
    func resetMessages() {
        errorMessage = nil
    }
    
    func fetchBudget() {
        guard budgetService.budgetSubject.value == nil else { return }
        performRequest(isLoading: \.isLoading, request: { [weak self] in
            return try await self?.budgetService.fetchBudget(userId: 5)
        }, completion: { [weak self] result in
            guard let self else { return }
            self.requestTimer?.cancel()
            switch result {
            case .success(let budget):
                if let budget {
                    self.budget = budget
                    self.requestTimer?.cancel()
                    updateBudget(budget)
                } else {
                    handleError(R.string.localizable.budgetErrorGeneral())
                    loadBudget()
                    self.requestTimer?.cancel()
                }
            case .failure:
                handleError(R.string.localizable.budgetErrorGeneral())
                loadBudget()
                self.requestTimer?.cancel()
            }
        })
    }
    
    private func loadBudget() {
        do {
            let budgetCD = try coreDataService.fetchCurrentBudget()
            if let budgetCD {
                let categories = budgetCD.categories.map { budgetCategoryCD in
                    return BudgetCategory(
                        name: budgetCategoryCD.name ?? "",
                        spent: Int(budgetCategoryCD.spent),
                        remaining: Int(budgetCategoryCD.remaining),
                        limit: Int(budgetCategoryCD.limit))
                }
                let loadBudget = Budget(income: Int(budgetCD.income), categories: categories)
                self.budget = loadBudget
            }
        } catch {
            print(BudgetCoreDataError.fetchFailed.localizedDescription)
        }
    }
    
    private func updateBudget(_ budget: Budget) {
        do {
            try self.coreDataService.updateBudget(budget: budget)
        } catch {
            print(BudgetCoreDataError.updateCategoryFailder)
        }
    }
    
    func refreshBudget() {
        guard !isRefreshing else { return }
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performRequest(isLoading: \.isRefreshing, request: { [weak self] in
                try await self?.budgetService.fetchBudget(userId: 5)
            }, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let budget):
                    guard let budget else {
                        self.handleError(R.string.localizable.budgetErrorGeneral())
                        self.requestTimer?.cancel()
                        return
                    }
                    self.budget = budget
                    self.updateBudget(budget)
                case .failure:
                    handleError(R.string.localizable.budgetErrorGeneral())
                    self.requestTimer?.cancel()
                }
            })
        }
    }
    
    func getColor(for categoryName: String) -> String {
        return coreDataService.fetchCategoryColor(for: categoryName) ?? "#CCCCCC"
    }
    
    func startNotification() {
        Task {
            do {
                let isRegistered = try await NotificationService.shared.registerForNotification()
                if isRegistered {
                    NotificationService.shared.startNotificationTimer()
                } else {
                    print("Нет доступа к уведомлениям")
                }
            } catch {
                print("Ошибка в получение уведомлений: \(error.localizedDescription)")
                
            }
        }
    }
}

private extension BudgetViewModel {
    func performRequest<T>(
        isLoading keyPath: ReferenceWritableKeyPath<BudgetViewModel, Bool>,
        request: @escaping () async throws -> T?,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        errorMessage = nil
        self[keyPath: keyPath] = true
        
        requestTask = Task {
            do {
                let result = try await request()
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            self[keyPath: keyPath] = false
            self.finishLoading?()
        }
        
        setupRequestTimer(keyPath: keyPath)
    }
    
    func setupRequestTimer(keyPath: ReferenceWritableKeyPath<BudgetViewModel, Bool>) {
        requestTimer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .prefix(1)
            .sink { [weak self] _ in
                self?.handleRequestTimeout(keyPath: keyPath)
            }
    }
    
    func handleRequestTimeout(keyPath: ReferenceWritableKeyPath<BudgetViewModel, Bool>) {
        self[keyPath: keyPath] = false
        handleError("Превышен лимит ожидания")
        requestTask?.cancel()
    }
    
    func handleError(_ message: String) {
        errorMessage = message
        requestTimer?.cancel()
    }
}

