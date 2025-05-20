//
//  Categort.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 19.05.2025.
//

import Foundation

class Category: Codable {
    let id: Int
    let name: String
    let spent: Int
    let remaining: Int
    let limit: Int
}
