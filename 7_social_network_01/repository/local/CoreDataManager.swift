//
//  CoreDataManager.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 3/7/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "__social_network_01")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func getContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getData<T: NSManagedObject>() -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: "AuthData")
        do {
            let dbWEntries = try context.fetch(fetchRequest)
            return dbWEntries
        } catch(let error) {
            print(error)
        }
        return []
    }
    
    func deleteElement<T: NSManagedObject>(element: T) {
        let context = persistentContainer.viewContext
        context.delete(element)
        try? context.save()
    }
    
    func deleteAll() {
        let context = self.getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: AuthData.fetchRequest())
        
        do {
            try context.execute(delete)
        } catch {
            print("cant clean coredata")
        }
    }
    
    func saveLocalUser(user: User) {
        let context = self.getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "AuthData", in: context) else {return}
        guard let entry = NSManagedObject(entity: entity, insertInto: context) as? AuthData else {return}
        
        entry.idUser = user.id
        entry.photo = user.photo
        
        try? context.save()
    }
}
