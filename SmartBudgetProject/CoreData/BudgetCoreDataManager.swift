//
//  BudgetCoreDataManager.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 07.06.2025.
//

import CoreData

enum BudgetCoreDataError: Error {
    case saveFailed
    case deleteFailed
    case fetchFailed
    case addCategoryFailed
    case updateCategoryFailder
    case contextSaveError
    
    var localizedDescription: String {
        switch self {
        case .saveFailed: return "Не удалось сохранить бюджет"
        case .deleteFailed: return "Не удалось удалить данные"
        case .fetchFailed: return "Не удалось загрузить данные"
        case .addCategoryFailed: return "Не удалось добавить категорию"
        case .contextSaveError: return "Ошибка сохранения контекста"
        case .updateCategoryFailder: return "Не удалось обновить бюджет"
        }
    }
}

final class BudgetCoreDataManager {
    private let coreDataStack = CoreDataStack.shared
    
    static let shared = BudgetCoreDataManager()
    
    private init() { }
    
    func saveBudget(income: Int, categories: [CategoryDto]) throws {
        do {
            try clearAllBudgetData()
        } catch {
            print(BudgetCoreDataError.saveFailed.localizedDescription)
        }
        let budgetCD = BudgetCD(context: viewContext)
        budgetCD.income = Int32(income)
        
        for categoryDto in categories {
            try addCategory(to: budgetCD, categoryDto: categoryDto, income: income)
        }
        
        try saveContext()
    }
    
    func updateBudget(budget: Budget?) throws {
        guard let budget else { return } 
        guard let currentBudget = try fetchCurrentBudget() else { return }
        currentBudget.income = Int32(budget.income)
        
        let coreDataCategories = currentBudget.categories
        for budgetCategory in budget.categories {
            if let categoryCD = coreDataCategories.first(where: { $0.name == budgetCategory.name }) {
                categoryCD.limit = Int32(budgetCategory.limit)
                categoryCD.remaining = Int32(budgetCategory.remaining)
                categoryCD.spent = Int32(budgetCategory.spent)
                let percentage = (budgetCategory.limit * 100) / budget.income
                categoryCD.persentage = Int32(percentage)
            }
        }
        try saveContext()
    }
    
    func fetchCategoryColor(for categoryName: String) -> String? {
        let request = NSFetchRequest<NSDictionary>(entityName: "BudgetCategoryCD")
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        request.fetchLimit = 1
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["iconColor"]
        
        do {
            let result = try viewContext.fetch(request)
            return result.first?["iconColor"] as? String
        } catch {
            print("Error fetching color: \(error)")
            return nil
        }
    }
    
    private func addCategory(to budgetCD: BudgetCD, categoryDto: CategoryDto, income: Int) throws {
        let limit = (income * categoryDto.persentage) / 100
        
        let categoryCD = BudgetCategoryCD(context: viewContext)
        categoryCD.name = categoryDto.name
        categoryCD.persentage = Int32(categoryDto.persentage)
        categoryCD.limit = Int32(limit)
        categoryCD.spent = 0
        categoryCD.remaining = Int32(limit)
        categoryCD.iconColor = categoryDto.iconColor
        categoryCD.iconName = categoryDto.iconName
        
        budgetCD.addToBudgetCategory(categoryCD)
    }
    
    func clearAllBudgetData() throws {
        let budgetRequest: NSFetchRequest<BudgetCD> = BudgetCD.fetchRequest()
        let categoryRequest: NSFetchRequest<BudgetCategoryCD> = BudgetCategoryCD.fetchRequest()
        
        do {
            let budgets = try viewContext.fetch(budgetRequest)
            let categories = try viewContext.fetch(categoryRequest)
            
            budgets.forEach { viewContext.delete($0) }
            categories.forEach { viewContext.delete($0) }
            
            try saveContext()
        } catch {
            viewContext.rollback()
            throw BudgetCoreDataError.deleteFailed
        }
    }
    
    func fetchCurrentBudget() throws -> BudgetCD? {
        let request: NSFetchRequest<BudgetCD> = BudgetCD.fetchRequest()
        do {
            return try viewContext.fetch(request).first
        } catch {
            throw BudgetCoreDataError.fetchFailed
        }
    }
    
    private func saveContext() throws {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            throw BudgetCoreDataError.contextSaveError
        }
    }
}

extension BudgetCoreDataManager {
    var viewContext: NSManagedObjectContext {
        coreDataStack.viewContext
    }
}
