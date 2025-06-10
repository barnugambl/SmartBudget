//
//  LoginService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

protocol LoginServiceProtocol {
    func getUsers(loginForm: LoginForm) async throws -> AuthResponse?
}

class LoginService: LoginServiceProtocol {
    let loginAPIService: LoginAPIServiceProtocol
    
    init(loginAPIService: LoginAPIServiceProtocol) {
        self.loginAPIService = loginAPIService
    }
        
    func getUsers(loginForm: LoginForm) async throws -> AuthResponse? {
        do {
            return try await loginAPIService.getUser(loginForm: loginForm)
        } catch {
            print("Не удалось получить пользователя: \(error)")
            return nil
        }
    }
}
