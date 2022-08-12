//
//  Club+CoreDataClass.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(Club)
public class Club: NSManagedObject {
    
    class func allObjectsClub(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> [Club]? {
        let request = NSFetchRequest<Club>(entityName: "Club")
        let result = try? ctx?.fetch(request)
        
        return result
    }
    
    class func createNewObjectClub(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> Club? {
        guard let ctx = ctx else { return nil }
        let result = NSEntityDescription.insertNewObject(forEntityName: "Club", into: ctx)
        return result as? Club
    }

    
    var emblem: UIImage? {
        get {
            guard let name = emblemClubName else { return nil }
            return FileManager.default.loadImageFromCache(name: name)
        }
        set {
            guard let icon = newValue else {
                emblemClubName = nil
                return
            }
            emblemClubName = FileManager.default.saveImageToCache(img: icon)
        }
    }      
}
