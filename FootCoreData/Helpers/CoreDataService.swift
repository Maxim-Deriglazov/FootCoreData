//
//  CoreDataService.swift
//  MyCoreData
//
//  Created by Max on 20.07.2022.
//

import CoreData

class CoreDataService: NSObject {

    static let shared = CoreDataService()
    
    override init() {
        super.init()
        persistentContainer = loadContainer()
    }
    
    // MARK: - Core Data stack

    private var persistentContainer: NSPersistentContainer?
        
    private func loadContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "FootModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print(String(describing: storeDescription.url))
                self.context = container.viewContext
            }
        })
        return container
    }
    
    var context: NSManagedObjectContext?

    // MARK: - Core Data Saving support

    func saveContext () {
        guard let context = persistentContainer?.viewContext else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
