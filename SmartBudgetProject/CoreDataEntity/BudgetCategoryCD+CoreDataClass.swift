//
//  BudgetCategoryCD+CoreDataClass.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//
//

import Foundation
import CoreData

@objc(BudgetCategoryCD)
public class BudgetCategoryCD: NSManagedObject {

}

extension BudgetCategoryCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCategoryCD> {
        return NSFetchRequest<BudgetCategoryCD>(entityName: "BudgetCategoryCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var persentage: Int32
    @NSManaged public var limit: Int32
    @NSManaged public var spent: Int32
    @NSManaged public var remaining: Int32
    @NSManaged public var iconColor: String?
    @NSManaged public var iconName: String?
    @NSManaged public var budget: BudgetCD?

}

extension BudgetCategoryCD: Identifiable {

}

extension BudgetCategoryCD {
    func toBudgetCategory() -> BudgetCategory {
        return BudgetCategory(
            name: name ?? "",
            spent: Int(spent),
            remaining: Int(remaining),
            limit: Int(limit)
        )
    }
}
