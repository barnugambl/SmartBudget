//
//  ApiServiceProtocol.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

protocol APIServiceProtocol {
    init(baseURL: String, session: URLSession)
    
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T
    func patch<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T
    func delete(endpoint: String) async throws
}
