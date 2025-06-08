//
//  LogVIewModel.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 27.04.2025.
//

import Foundation
import Combine

enum ErrorFieldLogin {
    case phoneNumber
    case password
}

final class LoginViewModel {
    private let loginService: LoginServiceProtocol
    private let coreDataManager = UserCoreDataManager.shared
    
    // Input
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    
    // Output
    @Published private(set) var errorMessageField: String?
    @Published private(set) var errorMessage: String?
    @Published private(set) var errorField: ErrorFieldLogin?
        
    private var cleanPhoneNumber: String {
        phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
    }
    
    func isLogin(completion: @escaping (Bool) -> Void) {
        guard validatePhoneNumber(), validatePassword() else {
            completion(false)
            return
        }
        let loginForm = LoginForm(phoneNumber: cleanPhoneNumber, password: password)
        Task {
            do {
                if let responce = try await loginService.getUsers(loginForm: loginForm) {
                    UserDefaultsService.shared.isLogged = true
                    print(UserDefaultsService.shared.isLogged)
                    coreDataManager.saveUser(response: responce)
                    completion(true)
                } else {
                    errorMessage = "Не верный логин или пароль"
                    completion(false)
                }
            } catch {
                print("Не удалось войти: \(error)")
                completion(false)
            }
        }
    }
}

// MARK: Validation
private extension LoginViewModel {
    func validatePhoneNumber() -> Bool {
        guard !cleanPhoneNumber.isEmpty else {
            errorMessageField = "Номер не должен быть пустым"
            errorField = .phoneNumber
            return false
        }
        
        guard cleanPhoneNumber.count == 12 else {
            errorMessageField = "Номер должен содержать 11 символов"
            errorField = .phoneNumber
            return false
        }
        return true
    }
    
    func validatePassword() -> Bool {
        guard !password.isEmpty else {
            errorMessageField = "Пароль не должен быть пустым"
            errorField = .password
            return false
        }
        return true
    }
}
