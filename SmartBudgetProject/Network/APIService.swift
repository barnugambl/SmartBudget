//
//  ApiService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

final class ApiService: APIServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    
    init(baseURL: String = "http://46.29.161.201:8080/api/v1",
         session: URLSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        try await request(endpoint: endpoint, parameters: parameters)
    }
    
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        try await request(endpoint: endpoint, method: .POST, body: body)
    }
    
    func patch<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        try await request(endpoint: endpoint, method: .PATCH, body: body)
    }
    
    func put<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        try await request(endpoint: endpoint, method: .PUT, body: body)
    }
    
    func delete<T: Decodable>(endpoint: String) async throws -> T {
        try await request(endpoint: endpoint, method: .DELETE)
    }
}

private extension ApiService {
    func request<T: Decodable>(endpoint: String,
                               method: HttpType = .GET,
                               parameters: [String: Any]? = nil,
                               body: Encodable? = nil,
                               customHeaders: [String: String]? = nil ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        var headers = customHeaders ?? [:]
        
        headers["Content-type"] = "application/json"
        
        if let accessToken = UserCoreDataManager.shared.getCurrentUser()?.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters {
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
                request.url = urlComponents.url
            }
        }
        
        if let body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
        }
        
        do {
            let (data, responce) = try await session.data(for: request)
            guard let httpResponce = responce as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            guard (200...299).contains(httpResponce.statusCode) else { throw NetworkError.statusCode(httpResponce.statusCode) }
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

