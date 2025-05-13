//
//  Category.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.05.2025.
//

import UIKit

struct Category: Hashable {
    let id: UUID = UUID()
    let name: String
    let iconName: String
    let iconColor: UIColor
    let persent: Int
}
