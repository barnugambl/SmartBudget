//
//  LoginScreenBulder.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

final class LoginScreenBulder {
    
    private let loginService = LoginService(loginAPIService: LoginAPIService(apiService: ApiService()))
    
    func makeLoginScreen() -> LoginViewConroller {
        let viewModel = LoginViewModel(loginService: loginService)
        return LoginViewConroller(viewModel: viewModel)
    }
    
}
