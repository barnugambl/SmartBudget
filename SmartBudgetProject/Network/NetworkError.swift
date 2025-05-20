//
//  NetworkError.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 17.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case encodingError(Error)
}
