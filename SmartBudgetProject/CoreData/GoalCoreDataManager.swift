//
//  GoalCoreDataManager.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 07.06.2025.
//

import CoreData

final class GoalCoreDataManager {
    private let coreDataStack = CoreDataStack.shared
    
    static let shared = GoalCoreDataManager()
    
    private init() { }
    
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

extension GoalCoreDataManager {
    var viewContext: NSManagedObjectContext {
        coreDataStack.viewContext
    }
    
    func saveContext() {
        coreDataStack.saveContext()
    }
}
