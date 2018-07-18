//
//  CoreDateManager.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/17/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    enum EntityType {
        case Urinate
        case Medication
    }
    
    
    
    public lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HealthTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func applicationDocumentsDirectory() -> URL {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bartjacobs.Core_Data" in the application's documents Application Support directory.
        //let urls = FileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func clearEntity(_ name: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try context.execute(request)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func createNewObject(ofType type: EntityType, objectDictionary dict: [String : Any]) -> NSManagedObject? {
        
        switch type {
        case .Urinate:
            return createNewUrinate(fromDict: dict)
        case .Medication:
            return createNewMedication(fromDictionary: dict)
        }
        
    }
    
    private func createNewUrinate(fromDict dict: [String : Any]) -> Urinate? {
        guard let date = dict["date"] as? String,
            let time = dict["time"] as? String,
            let amount = dict["amount"] as? Int16 else {
            print("error: unable to get all data from dictionary")
            return nil
        }
        let newUrinate = Urinate(context: context)
        newUrinate.date = date
        newUrinate.time = time
        newUrinate.amount = amount
        return newUrinate
    }
    
    private func createNewMedication(fromDictionary dict: [String : Any]) -> Medication? {
        guard let name = dict["name"] as? String,
            let purpose = dict["purpose"] as? String,
            let dosage = dict["dosage"] as? Int16,
            let frequency = dict["frequency"] as? Int16 else {
            print("error: unable to get all data from dictionary")
            return nil
        }
        let newMedication = Medication(context: context)
        newMedication.name = name
        newMedication.purpose = purpose
        newMedication.frequency = frequency
        newMedication.dosage = dosage
        return newMedication
    }
    
    private func date(fromString dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.Normal
        return formatter.date(from: dateString)
    }
    
    
    // TODO: add export functionality
    
}
