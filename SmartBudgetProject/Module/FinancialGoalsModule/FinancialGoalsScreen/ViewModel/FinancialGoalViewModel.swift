//
//  FinancialGoalViewmOdel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import Foundation
import Combine

final class FinancialGoalViewModel {
    let financialGoalService: FinancialGoalServiceProtocol
    private var requestTimer: AnyCancellable?
    private var requestTask: Task<Void, Never>?
    private var coreDataService = GoalCoreDataManager.shared
    let userId: Int
    
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    
    // Output
    @Published private(set) var errorMessageField: String?
    @Published private(set) var errorMessage: String?
    @Published private(set) var successMessage: String?
    @Published var financialGoals: [Goal] = []
    var finishLoading: (() -> Void)?
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(userId: Int, financialGoalService: FinancialGoalServiceProtocol) {
        self.userId = userId
        self.financialGoalService = financialGoalService
        resetMessages()
    }
    
    func resetMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    func fetchFinancialGoals() {
        performRequest(isLoading: \.isLoading, request: { [weak self] in
            return try await self?.financialGoalService.fetchFinancialGoals(userId: self?.userId ?? 0)
        },
        completion: { [weak self] result in
            guard let self else { return }
            self.requestTimer?.cancel()
            switch result {
            case .success(let goals):
                if let goals = goals {
                    self.financialGoals = goals
                    self.coreDataService.saveFinancialGoals(goals)
                } else {
                    self.loadCachedGoals()
                    self.handleError(R.string.localizable.goalGeneralError())
                }
            case .failure:
                self.loadCachedGoals()
                self.handleError(R.string.localizable.goalGeneralError())
            }
        })
    }
    
    private func loadCachedGoals() {
        let cachedGoals = coreDataService.getAllFinancialGoals()
        if !cachedGoals.isEmpty {
            self.financialGoals = cachedGoals
        }
    }
    
    func updateGoalToCoreDate(goal: Goal) {
        coreDataService.updateFinancialGoal(goal: goal)
    }
    
    func refreshFinancialGoals() {
        guard !isRefreshing else { return }
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performRequest(isLoading: \.isRefreshing, request: { [weak self] in
                try await self?.financialGoalService.fetchFinancialGoals(userId: self?.userId ?? 0)
            }, completion: { [weak self] result in
                guard let self else { return }
                self.requestTimer?.cancel()
                switch result {
                case .success(let goal):
                    guard let goal else {
                        self.handleError(R.string.localizable.goalGeneralError())
                        return
                    }
                    self.financialGoals = goal
                    self.coreDataService.saveFinancialGoals(goal)
                case .failure:
                    self.handleError(R.string.localizable.goalGeneralError())
                }
            }
            )
        }
    }
    
    func deleteFinancialGoal(goalId: Int) {
        Task {
            do {
                if try await financialGoalService.deleteFinancialGoal(userId: userId, goalId: goalId) != nil {
                    handleSuccess(R.string.localizable.goalDeleteSuccess()) {
                        self.financialGoals.removeAll(where: { $0.goalId == goalId })
                        self.coreDataService.deleteFinancialGoal(by: Int64(goalId))
                        
                    }
                } else {
                    errorMessage = (R.string.localizable.goalGeneralError())
                }
            } catch {
                print("Не удалось удалить цель: \(error.localizedDescription)")
            }
        }
    }
    
}

private extension FinancialGoalViewModel {
    func performRequest<T>(
        isLoading keyPath: ReferenceWritableKeyPath<FinancialGoalViewModel, Bool>,
        request: @escaping () async throws -> T?,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        errorMessage = nil
        self[keyPath: keyPath] = true
        setupRequestTimer(keyPath: keyPath)

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
    }
    
    func setupRequestTimer(keyPath: ReferenceWritableKeyPath<FinancialGoalViewModel, Bool>) {
        requestTimer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .prefix(1)
            .sink { [weak self] _ in
                self?.handleRequestTimeout(keyPath: keyPath)
            }
    }
    
    func handleRequestTimeout(keyPath: ReferenceWritableKeyPath<FinancialGoalViewModel, Bool>) {
        self[keyPath: keyPath] = false
        handleError(R.string.localizable.goalTimeoutError())
        requestTask?.cancel()
    }
    
    func handleError(_ message: String) {
        errorMessage = message
        requestTimer?.cancel()
    }
    
    func handleSuccess(_ message: String, action: (() -> Void)? = nil) {
        successMessage = message
        action?()
    }
}
