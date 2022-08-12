//
//  League+CoreDataProperties.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData


extension League {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<League> {
        return NSFetchRequest<League>(entityName: "League")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var country: String?
    @NSManaged public var emblemName: String?
    @NSManaged public var name: String?
    @NSManaged public var legClub: NSSet?

}

// MARK: Generated accessors for legClub
extension League {

    @objc(addLegClubObject:)
    @NSManaged public func addToLegClub(_ value: Club)

    @objc(removeLegClubObject:)
    @NSManaged public func removeFromLegClub(_ value: Club)

    @objc(addLegClub:)
    @NSManaged public func addToLegClub(_ values: NSSet)

    @objc(removeLegClub:)
    @NSManaged public func removeFromLegClub(_ values: NSSet)

}

extension League : Identifiable {

}
