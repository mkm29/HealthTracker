//
//  CoreDateManager.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/17/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    var applicationsDocumentDirectory: String {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return documentsURL.absoluteString.replacingOccurrences(of: "%20", with: "\\ ")
    }
    
    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
    
    
    func createNewObject(ofType type: Constants.EntityType, objectDictionary dict: [String : Any]) -> NSManagedObject? {
        var newObject: NSManagedObject?
        
        switch type {
        case .Cath:
            newObject = newCath(fromDict: dict)
        case .Medication:
            newObject = newMedication(fromDictionary: dict)
        case .Bowel:
            newObject = newBowel(fromDict: dict)
        case .Physician:
            newObject = newPysician(fromDict: dict)
        case .Note:
            newObject = newNote(fromDict: dict)
        case .Order, .Supply, .Appointment:
            break
        }
        return newObject
    }
    
    func get(entityType: Constants.EntityType, predicate: NSPredicate) -> Any? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityType.rawValue)
        request.predicate = predicate
        do {
            return try context.fetch(request).first
        } catch {
            print(error.localizedDescription as Any)
        }
        return nil
    }
    
    private func newCath(fromDict dict: [String : Any]) -> Cath? {
        guard let timestamp = dict["timestamp"] as? Date, let amount = dict["amount"] as? Int16 else {
            print("CoreData Error:", "Could not find timestamp")
            return nil
        }
        if let existingCath = get(entityType: Constants.EntityType.Cath, predicate: NSPredicate(format: "timestamp == %@", timestamp as CVarArg)) {
            return existingCath as? Cath
        }
        let newCath = Cath(context: context)
        newCath.timestamp = timestamp
        newCath.date = timestamp.string(withFormat: Constants.DateFormat.Normal)
        newCath.amount = amount
        
        if let documentID = dict["documentID"] as? String {
            newCath.documentID = documentID
        }
        
        return newCath
    }
    

    
    private func newMedication(fromDictionary dict: [String : Any]) -> Medication? {
        guard  let name = dict["name"] as? String else {
            print("CoreData Error:", "Could not get name for medication.")
            return nil
        }
        if let foundMedication = get(entityType: .Medication, predicate: NSPredicate(format: "name == %@", name)) {
            return foundMedication as? Medication
        }
        let newMedication = Medication(context: context)
        newMedication.name = name
        newMedication.purpose = dict["purpose"] as? String
        newMedication.imagePath = dict["imagePath"] as? String
        newMedication.prescription = dict["prescription"] as? Bool ?? true
        newMedication.active = dict["active"] as? Bool ?? true
        newMedication.pillboxImageURL = dict["pillboxImageURL"] as? String
        if let dosage = dict["dosage"] as? Int16 {
            newMedication.dosage = dosage
        }
        if let frequency = dict["frequency"] as? Int16 {
            newMedication.frequency = frequency
        }
        if let documentID = dict["documentID"] as? String {
            newMedication.documentID = documentID
        }

        return newMedication
    }
    
    private func newBowel(fromDict dict: [String:Any]) -> Bowel? {
        guard let timestamp = dict["timestamp"] as? Date, let intensity = dict["intensity"] as? Int16 else {
            print("CoreData Error:", "Could not get timestamp")
            return nil
        }
        
        let newBowel = Bowel(context: context)
        newBowel.timestamp = timestamp
        newBowel.date = timestamp.string(withFormat: Constants.DateFormat.Normal)
        newBowel.intensity = intensity
        
        if let documentID = dict["documentID"] as? String {
           newBowel.documentID = documentID
        }
        return newBowel
    }
    
    private func newPysician(fromDict dict: [String:Any]) -> Physician? {
        guard let givenName = dict["givenName"] as? String,
            let familyName = dict["familyName"] as? String else {
            print("CoreData Error", "There was an issue creating new Physician object: unable to parse data.")
            return nil
        }
        if let foundPhysician = get(entityType: .Physician, predicate: NSPredicate(format: "givenName == %@ AND familyName == %@", argumentArray: [givenName, familyName])) {
            return foundPhysician as? Physician
        }
        
        let newPhysician = Physician(context: context)
        newPhysician.givenName = givenName
        newPhysician.familyName = familyName
        newPhysician.specialty = dict["specialty"] as? String
        newPhysician.medicalEducation = dict["medicalEducation"] as? String
        newPhysician.contactIdentifier = dict["contactIdentifier"] as? String

        return newPhysician
    }
    
    private func newNote(fromDict dict: [String: Any]) -> Note? {
        guard let noteTitle = dict["title"] as? String,
            let noteBody = dict["body"] as? String else {
            AppDelegate.getAppDelegate().showAlert("Error", "There was an issue creating new Mote object: unable to parse data.")
            return nil
        }
        let newNote = Note(context: context)
        newNote.body = noteBody
        newNote.title = noteTitle
        newNote.timestamp = Date()
        newNote.date = newNote.timestamp?.string(withFormat: Constants.DateFormat.Normal)
        return newNote
    }
    
}
