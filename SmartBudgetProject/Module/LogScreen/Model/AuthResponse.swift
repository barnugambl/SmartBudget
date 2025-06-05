//
//  AuthResponse.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation

struct AuthResponse: Codable {
    let userId: Int
    let jwtTokenPairDto: JwtTokenPairDto
    
    struct JwtTokenPairDto: Codable {
        let accessToken: String
        let refreshToken: String
    }
}
