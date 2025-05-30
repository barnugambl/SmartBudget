//
//  CategoryDto.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 26.05.2025.
//

import Foundation
import UIKit

struct CategoryDto {
    let name: String
    let iconName: String
    var iconColor: UIColor
    var persentage: Int
    
    static func defaultCategories() -> [CategoryDto] {
        return [
            .init(name: R.string.localizable.productsCategoryButton(),
                  iconName: R.image.food_icon.name,
                  iconColor: .systemGreen, persentage: 16),
            .init(name: R.string.localizable.transportCategoryButton(),
                  iconName: R.image.transport_icon.name,
                  iconColor: .systemBlue, persentage: 16),
            .init(name: R.string.localizable.utilitiesCategoryButton(),
                  iconName: R.image.faucet_icon.name,
                  iconColor: .systemYellow, persentage: 16),
            .init(name: R.string.localizable.divorcesCategoryButton(),
                  iconName: R.image.event_icon.name,
                  iconColor: .systemPurple, persentage: 16),
            .init(name: R.string.localizable.accumulationsCategoryButton(),
                  iconName: R.image.coins_icon.name,
                  iconColor: .systemOrange, persentage: 16),
            .init(name: R.string.localizable.otherCategoryButton(),
                  iconName: R.image.other_icon.name,
                  iconColor: .systemGray, persentage: 20)
        ]
    }
    
    func toRequset() -> Category {
        return Category(name: name, percentage: persentage)
    }
}
