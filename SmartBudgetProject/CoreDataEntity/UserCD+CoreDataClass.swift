//
//  UserCD+CoreDataClass.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//
//

import Foundation
import CoreData

@objc(UserCD)
public class UserCD: NSManagedObject {

}

extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var refreshToken: String?
    @NSManaged public var accessToken: String?
    @NSManaged public var budget: BudgetCD?
    @NSManaged public var financialGoal: NSSet?

}

// MARK: Generated accessors for financialGoal
extension UserCD {

    @objc(addFinancialGoalObject:)
    @NSManaged public func addToFinancialGoal(_ value: FinancialGoalCD)

    @objc(removeFinancialGoalObject:)
    @NSManaged public func removeFromFinancialGoal(_ value: FinancialGoalCD)

    @objc(addFinancialGoal:)
    @NSManaged public func addToFinancialGoal(_ values: NSSet)

    @objc(removeFinancialGoal:)
    @NSManaged public func removeFromFinancialGoal(_ values: NSSet)

}

extension UserCD: Identifiable {

}
