//
//  UserDefaultsService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 05.06.2025.
//

import Foundation
import UIKit

class UserDefaultsService {
    private let userDefaults: UserDefaults
    
    static let shared = UserDefaultsService()
    
    private enum Keys {
        static let categoryDto = "categoryDto"
    }
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

// MARK: User Categories
extension UserDefaultsService {
    var categoryDto: [CategoryDto]? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.categoryDto) else {
                return nil
            }
            do {
                let categories = try JSONDecoder().decode([CategoryDto].self, from: data)
                return categories
            } catch {
                print("Failed to decode:\(error)")
                return nil
            }
        }
        set {
            if let categories = newValue {
                do {
                    let data = try JSONEncoder().encode(categories)
                    UserDefaults.standard.set(data, forKey: Keys.categoryDto)
                } catch {
                    print("Failed to encode: \(error)")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.categoryDto)
            }
        }
    }
}
