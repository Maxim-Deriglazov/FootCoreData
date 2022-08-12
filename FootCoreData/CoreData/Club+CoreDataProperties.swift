//
//  Club+CoreDataProperties.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData


extension Club {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Club> {
        return NSFetchRequest<Club>(entityName: "Club")
    }
    
    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var championsLeague: Bool
    @NSManaged public var emblemClubName: String?
    @NSManaged public var clubLeag: League?
    @NSManaged public var clubPlay: NSSet?
}

// MARK: Generated accessors for clubPlay
extension Club {

    @objc(addClubPlayObject:)
    @NSManaged public func addToClubPlay(_ value: Player)

    @objc(removeClubPlayObject:)
    @NSManaged public func removeFromClubPlay(_ value: Player)

    @objc(addClubPlay:)
    @NSManaged public func addToClubPlay(_ values: NSSet)

    @objc(removeClubPlay:)
    @NSManaged public func removeFromClubPlay(_ values: NSSet)

}

extension Club : Identifiable {

}
