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
            return try await self?.budgetService.mockFetchBudget()
        },
                       completion: { [weak self] result in
            self?.handleBudgetResult(result)
        })
    }
    
    func refreshBudget() {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performRequest(isLoading: \.isRefreshing, request: { [weak self] in
                try await self?.budgetService.mockFetchBudget()
            },
                                 completion: { [weak self] result in
                self?.handleBudgetResult(result)
            })
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
    
    func handleBudgetResult(_ result: Result<Budget?, Error>) {
        switch result {
        case .success(let budget):
            if let budget = budget {
                self.budget = budget
                requestTimer?.cancel()
            } else {
                handleError("Упс произошла ошибка, попробуйте еще раз")
            }
        case .failure:
            handleError("Упс произошла ошибка, попробуйте еще раз")
        }
    }
    
    func handleError(_ message: String) {
        errorMessage = message
        requestTimer?.cancel()
    }
}

