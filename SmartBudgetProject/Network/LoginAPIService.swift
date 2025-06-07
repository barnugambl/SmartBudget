//
//  LoginAPIService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

final class LoginAPIService: LoginAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getUser(loginForm: LoginForm) async throws -> AuthResponse {
        try await apiService.post(endpoint: URLConstantLogin.login, body: loginForm)
    }
}
