//
//  Coach+CoreDataClass.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(Coach)
public class Coach: NSManagedObject {
    
    var fullName: String {
        return (name ?? "") + " " + (lastName ?? "")
    }
    
//    func image() -> UIImage {
////        ..
//        return UIImage()
//    }
    
    class func allObjectsCoach(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> [Coach]? {
        let request = NSFetchRequest<Coach>(entityName: "Coach")
        let result = try? ctx?.fetch(request)
        
        return result
    }// выборка обьектов Coach из кор дат
    
    class func createNewObjectCoach(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> Coach? {
        guard let ctx = ctx else { return nil }
        let result = NSEntityDescription.insertNewObject(forEntityName: "Coach", into: ctx)
//        CoreDataService.shared.saveContext()
        return result as? Coach
    }//создание обьекта Coach в кор дата

}
