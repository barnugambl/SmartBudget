//
//  NetworkError.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 17.05.2025.
//

import Foundation

struct ErrorResponse: Decodable {
    let message: String
    let status: Int?
    let path: String?
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int, String)
    case decodingError(Error)
    case serverError(message: String)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .statusCode(let code, let message):
            return "Ошибка \(code): \(message)"
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .serverError(let message):
            return "Ошибка сервера: \(message)"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}

