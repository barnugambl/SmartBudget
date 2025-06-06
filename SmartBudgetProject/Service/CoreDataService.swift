//
//  CoreDataService.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    
}

final class CoreDataService: CoreDataServiceProtocol {
    
    static let shared = CoreDataService()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmartBudgetProject")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// MARK: FinancialGoal
extension CoreDataService {
    func getAllFinancialGoals() -> [Goal] {
        let fetchRequest: NSFetchRequest<FinancialGoalCD> = FinancialGoalCD.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest).compactMap { goalCD in
                return goalCD.toGoal()
            }
        } catch {
            print("Ошибка при получении целей: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveFinancialGoals(_ goals: [Goal]) {
        deleteAllFinancialGoals()
        goals.forEach { goal in
            saveFinancialGoal(goal: goal)
        }
        saveContext()
    }
    
    func deleteAllFinancialGoals() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FinancialGoalCD.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Ошибка при удалении всех целей: \(error.localizedDescription)")
        }
    }
    
    func deleteFinancialGoal(by id: Int64) {
        let fetchRequest: NSFetchRequest<FinancialGoalCD> = FinancialGoalCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        do {
            guard let goalToDelete = try viewContext.fetch(fetchRequest).first else {
                print("Цель с ID \(id) не найдена")
                return
            }
            viewContext.delete(goalToDelete)
            saveContext()
        } catch {
            print("Ошибка при удалении цели: \(error.localizedDescription)")
        }
    }
    
    func updateFinancialGoal(goal: Goal) {
        if let goalCD = getFinancialGoalCD(by: Int64(goal.id)) {
            goalCD.name = goal.name
            goalCD.targetAmount = Int32(goal.targetAmount)
            goalCD.savedAmount = Int32(goal.savedAmount)
            goalCD.recommendedMonthlySaving = Int32(goal.recommendedMonthlySaving)
            goalCD.deadline = goal.deadline
            goalCD.status = goal.status.rawValue
            saveContext()
        }
    }
    
    private func getFinancialGoalCD(by id: Int64) -> FinancialGoalCD? {
        let fetchRequest: NSFetchRequest<FinancialGoalCD> = FinancialGoalCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            return try viewContext.fetch(fetchRequest).first
        } catch {
            print("Ошибка при получении цели из CoreData: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveFinancialGoal(goal: Goal) {
        let entity = FinancialGoalCD.entity()
        let goalCD = FinancialGoalCD(entity: entity, insertInto: viewContext)
        goalCD.id = Int64(goal.id)
        goalCD.name = goal.name
        goalCD.targetAmount = Int32(goal.targetAmount)
        goalCD.savedAmount = Int32(goal.savedAmount)
        goalCD.recommendedMonthlySaving = Int32(goal.recommendedMonthlySaving)
        goalCD.deadline = goal.deadline
        goalCD.status = goal.status.rawValue
        goalCD.user = nil
        
        do {
            try viewContext.save()
        } catch {
            print("Ошибка при сохранении цели: \(error.localizedDescription)")
        }
    }
}

extension CoreDataService {
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
