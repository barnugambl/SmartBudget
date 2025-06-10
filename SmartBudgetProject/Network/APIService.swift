//
//  ApiService.swift
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
    func put<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T
    func delete<T: Decodable>(endpoint: String) async throws -> T
}

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
    func request<T: Decodable>(
        endpoint: String,
        method: HttpType = .GET,
        parameters: [String: Any]? = nil,
        body: Encodable? = nil,
        customHeaders: [String: String]? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        var headers = customHeaders ?? [:]
        headers["Content-Type"] = "application/json"
        
        if let accessToken = UserCoreDataManager.shared.getCurrentUser()?.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        var logMessage = """
        \n🚀 Отправка запроса:
        \(method.rawValue) \(url.absoluteString)
        Headers: \(headers)
        """
        
        if let parameters, !parameters.isEmpty {
            logMessage += "\nQuery Parameters: \(parameters)"
        }
        
        if let body {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let bodyData = try encoder.encode(body)
            request.httpBody = bodyData
            
            if let bodyString = String(data: bodyData, encoding: .utf8) {
                logMessage += "\nBody:\n\(bodyString)"
            }
        }
        
        logMessage += "\n----------------------------------------"
        print(logMessage)
        
        print("cURL команда:\n\(curlString(for: request))")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            let responseString = String(data: data, encoding: .utf8) ?? "Нечитаемые данные"
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            print("""
            \n📥 Получен ответ:
            Status Code: \(statusCode)
            URL: \(request.url?.absoluteString ?? "N/A")
            Body:
            \(responseString)
            ----------------------------------------
            """)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw NetworkError.serverError(message: errorResponse.message)
                } else {
                    throw NetworkError.statusCode(httpResponse.statusCode, responseString)
                }
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch let decodingError {
                print("Ошибка декодирования:", decodingError)
                print("Сырые данные:", responseString)
                throw NetworkError.decodingError(decodingError)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    private func curlString(for request: URLRequest) -> String {
        var components = ["curl -v"]
        
        if let method = request.httpMethod {
            components.append("-X \(method)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                components.append("-H '\(key): \(value)'")
            }
        }
        
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            components.append("-d '\(bodyString)'")
        }
        
        if let url = request.url?.absoluteString {
            components.append("'\(url)'")
        }
        
        return components.joined(separator: " \\\n\t")
    }
}
