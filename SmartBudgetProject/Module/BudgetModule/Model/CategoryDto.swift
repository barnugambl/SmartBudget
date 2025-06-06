//
//  CategoryDto.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation

struct CategoryDto: Codable {
    let name: String
    let iconName: String
    var iconColor: String
    var persentage: Int
    
    static func defaultCategories() -> [CategoryDto] {
        return [
            .init(name: R.string.localizable.productsCategoryButton(),
                  iconName: R.image.food_icon.name,
                  iconColor: "#34C759",
                  persentage: 16),
            .init(name: R.string.localizable.transportCategoryButton(),
                  iconName: R.image.transport_icon.name,
                  iconColor: "#007AFF",
                  persentage: 16),
            .init(name: R.string.localizable.utilitiesCategoryButton(),
                  iconName: R.image.faucet_icon.name,
                  iconColor: "#FFCC00",
                  persentage: 16),
            .init(name: R.string.localizable.divorcesCategoryButton(),
                  iconName: R.image.event_icon.name,
                  iconColor: "#AF52DE",
                  persentage: 16),
            .init(name: R.string.localizable.accumulationsCategoryButton(),
                  iconName: R.image.coins_icon.name,
                  iconColor: "#FF9500",
                  persentage: 16),
            .init(name: R.string.localizable.otherCategoryButton(),
                  iconName: R.image.other_icon.name,
                  iconColor: "#8E8E93",  
                  persentage: 20)
        ]
    }
    
    func toRequset() -> Category {
        return Category(name: name, percentage: persentage)
    }
}
