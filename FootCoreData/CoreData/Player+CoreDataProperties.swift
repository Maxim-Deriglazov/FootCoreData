//
//  Player+CoreDataProperties.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }
    
    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var number: Int16
    @NSManaged public var position: String?
    @NSManaged public var height: String?
    @NSManaged public var injured: Bool
    @NSManaged public var photoURL: String?
    @NSManaged public var photo: String?
    @NSManaged public var playClub: Club?

}

extension Player : Identifiable {

}
