//
//  LoginAPIServiceProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

protocol LoginAPIServiceProtocol {
    func getUser(loginForm: LoginForm) async throws -> AuthResponse
}
