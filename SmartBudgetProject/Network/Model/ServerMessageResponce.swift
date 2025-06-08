//
//  ServerMessageResponce.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 20.05.2025.
//

import Foundation

struct ServerMessageResponce: Decodable {
    let message: String
    
    init(from decoder: Decoder) throws {
           let container = try decoder.singleValueContainer()
            message = try container.decode(String.self)
       }
}
