//
//  FinancialGoalCD+CoreDataClass.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 06.06.2025.
//
//

import Foundation
import CoreData

@objc(FinancialGoalCD)
public class FinancialGoalCD: NSManagedObject {

}

extension FinancialGoalCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinancialGoalCD> {
        return NSFetchRequest<FinancialGoalCD>(entityName: "FinancialGoalCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var targetAmount: Int32
    @NSManaged public var savedAmount: Int32
    @NSManaged public var recommendedMonthlySaving: Int32
    @NSManaged public var deadline: String?
    @NSManaged public var status: String?
    @NSManaged public var user: UserCD?

}

extension FinancialGoalCD: Identifiable {

}

extension FinancialGoalCD {
    func toGoal() -> Goal? {
        guard let name = name,
              let deadline = deadline,
              let statusString = status,
              let status = FinancialGoalStatus(rawValue: statusString) else {
            return nil
        }
        return Goal(
            id: Int(id),
            name: name,
            targetAmount: Int(targetAmount),
            savedAmount: Int(savedAmount),
            recommendedMonthlySaving: Int(recommendedMonthlySaving),
            deadline: deadline,
            status: status
        )
    }
}
