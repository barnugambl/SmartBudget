//
//  NotificationAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//

import Foundation

protocol NotificationAPIServiceProtocol {
    func getNotifications(userId: Int) async throws -> [Notification]?
}

final class NotificationAPIService: NotificationAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getNotifications(userId: Int) async throws -> [Notification]? {
        try await apiService.get(endpoint: URLConstansNotification.getNotification(userId: userId), parameters: nil)
    }
}
