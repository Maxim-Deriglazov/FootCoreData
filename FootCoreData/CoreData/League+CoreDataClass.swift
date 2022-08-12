//
//  League+CoreDataClass.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//

import Foundation
import CoreData
import UIKit

@objc(League)
public class League: NSManagedObject {
    
    class func allObjectsLeague(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> [League]? {
        let request = NSFetchRequest<League>(entityName: "League")
        let result = try? ctx?.fetch(request)
        
        return result
    }
    
    class func createNewObjectLeague(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> League? {
        guard let ctx = ctx else { return nil }
        let result = NSEntityDescription.insertNewObject(forEntityName: "League", into: ctx)
        return result as? League
    }

    class func object(id: String, ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> League? {
        let request = NSFetchRequest<League>(entityName: "League")
        request.predicate = NSPredicate(format: "identifier = %@", id)
        let result = try? ctx?.fetch(request)
        assert(result?.count ?? 0 < 2)
        return result?.first
    }
    
    var emblem: UIImage? {
        get {
            guard let name = emblemName else { return nil }
            return FileManager.default.loadImageFromCache(name: name)
        }
        set {
            guard let icon = newValue else {
                emblemName = nil
                return
            }
            emblemName = FileManager.default.saveImageToCache(img: icon)
        }
    }    
}
