//
//  Coach+CoreDataProperties.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData


extension Coach {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coach> {
        return NSFetchRequest<Coach>(entityName: "Coach")
    }
    
    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var lastName: String?
    @NSManaged public var photo: String?
    @NSManaged public var coacClub: Club?

}

extension Coach : Identifiable {

}
