//
//  UserCoreDataManager.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 07.06.2025.
//

import CoreData

final class UserCoreDataManager {
    private let coreDataStack = CoreDataStack.shared
    
    static let shared = UserCoreDataManager()
    
    private init() { }
    
    func saveUser(
        response: AuthResponse,
        in context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
            clearUserData()
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserCD.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                let newUser = UserCD(context: context)
                newUser.id = Int64(response.userId)
                newUser.refreshToken = response.jwtTokenPairDto.refreshToken
                newUser.accessToken = response.jwtTokenPairDto.accessToken
                print("Пользователь с id \(response.userId) создан")
                
                try context.save()
            } catch {
                print("Ошибка при сохранении пользователя: \(error)")
            }
        }
    
    func getCurrentUser(in context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> UserCD? {
        let fetchRequest: NSFetchRequest<UserCD> = UserCD.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при получении пользователя: \(error)")
            return nil
        }
    }
    
    func clearUserData(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserCD.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("Все пользовательские данные удалены")
        } catch {
            print("Ошибка при удалении пользователя: \(error)")
        }
    }
}

extension UserCoreDataManager {
    var viewContext: NSManagedObjectContext {
        coreDataStack.viewContext
    }
    
    private func saveContext() {
        coreDataStack.saveContext()
    }
}
