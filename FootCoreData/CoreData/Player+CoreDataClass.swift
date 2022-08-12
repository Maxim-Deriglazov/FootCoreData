//
//  Player+CoreDataClass.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(Player)
public class Player: NSManagedObject {
    
    var fullName: String {
        return (name ?? "") + " " + (lastName ?? "")
    }
    
    class func allObjectsPlayer(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> [Player]? {
        let request = NSFetchRequest<Player>(entityName: "Player")
        let result = try? ctx?.fetch(request)
        
        return result
    }
    
    class func createNewObjectPlayer(ctx: NSManagedObjectContext? = CoreDataService.shared.context) -> Player? {
        guard let ctx = ctx else { return nil }
        let result = NSEntityDescription.insertNewObject(forEntityName: "Player", into: ctx)
        return result as? Player
    }

    class func removeAllObjects() {
        let objects = allObjectsPlayer()
        objects?.forEach({ (player) in
            player.managedObjectContext?.delete(player)
        })
        CoreDataService.shared.saveContext()
    }
    
    static let PlayerPhotoUpdateNotification = NSNotification.Name(rawValue: "playerPhotoUpdateNotification")
    var emblem: UIImage? {
        get {
            guard let name = photo else { return nil }
            return FileManager.default.loadImageFromCache(name: name)
        }
        set {
            guard let icon = newValue else {
                photo = nil
                return
            }
            photo = FileManager.default.saveImageToCache(img: icon)
            
            NotificationCenter.default.post(name: Player.PlayerPhotoUpdateNotification, object: self)
        }
    }
    
    func fetchPhoto() {
        var img: UIImage?
        let url = URL(string: photoURL ?? "https://www.pinpng.com/pngs/m/341-3415688_no-avatar-png-transparent-png.png")
        DispatchQueue.background(delay: 0) {
            if let data = try? Data(contentsOf: url!) {
                img = UIImage(data: data)
            }
        } completion: {
            self.emblem = img
        }
    }
}
