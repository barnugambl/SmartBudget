//
//  LoginAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

enum UserError: Error {
    case userNotFound
    
    var localizedDescription: String {
        switch self {
        case .userNotFound: return "Пользователь не найден"
        }
    }
}

protocol LoginAPIServiceProtocol {
    func getUser(loginForm: LoginForm) async throws -> AuthResponse
}

final class LoginAPIService: LoginAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getUser(loginForm: LoginForm) async throws -> AuthResponse {
        try await apiService.post(endpoint: URLConstantLoginConstans.login, body: loginForm)
    }
}
