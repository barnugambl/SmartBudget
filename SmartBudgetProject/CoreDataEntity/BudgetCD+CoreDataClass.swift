//
//  BudgetCD+CoreDataClass.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//
//

import Foundation
import CoreData

@objc(BudgetCD)
public class BudgetCD: NSManagedObject {

}

extension BudgetCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCD> {
        return NSFetchRequest<BudgetCD>(entityName: "BudgetCD")
    }

    @NSManaged public var income: Int32
    @NSManaged public var user: UserCD?
    @NSManaged public var budgetCategory: NSSet?

}

// MARK: Generated accessors for budgetCategory
extension BudgetCD {

    @objc(addBudgetCategoryObject:)
    @NSManaged public func addToBudgetCategory(_ value: BudgetCategoryCD)

    @objc(removeBudgetCategoryObject:)
    @NSManaged public func removeFromBudgetCategory(_ value: BudgetCategoryCD)

    @objc(addBudgetCategory:)
    @NSManaged public func addToBudgetCategory(_ values: NSSet)

    @objc(removeBudgetCategory:)
    @NSManaged public func removeFromBudgetCategory(_ values: NSSet)

}

extension BudgetCD: Identifiable {

}
