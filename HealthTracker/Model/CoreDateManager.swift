//
//  CoreDateManager.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/17/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    public lazy var context: NSManagedObjectContext = {
        return AppDelegate.getAppDelegate().persistentContainer.viewContext
    }()
    
    class func applicationDocumentsDirectory() -> String {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bartjacobs.Core_Data" in the application's documents Application Support directory.
        //let urls = FileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let path = urls[urls.count-1].absoluteString.replacingOccurrences(of: "%20", with: "\\ ")
        return path
    }
    
    // MARK: - Core Data Saving support
    
    class func clearEntity(_ name: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try AppDelegate.getAppDelegate().persistentContainer.viewContext.execute(request)
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
        AppDelegate.getAppDelegate().saveContext()
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
        guard let timestamp = dict["timestamp"] as? Date else {
            print("CoreData Error:", "Could not find timestamp")
            return nil
        }
        if let existingCath = get(entityType: Constants.EntityType.Cath, predicate: NSPredicate(format: "timestamp == %@", timestamp as CVarArg)) {
            return existingCath as? Cath
        }
        if let amount = dict["amount"] as? Int16 {
            let newCath = Cath(context: context)
            newCath.timestamp = timestamp
            newCath.date = timestamp.string(withFormat: Constants.DateFormat.Normal)
            newCath.amount = amount
        } else {
            print("Could not get amount")
        }
        return nil
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

        return newMedication
    }
    
    private func newBowel(fromDict dict: [String:Any]) -> Bowel? {
        guard let timestamp = dict["timestamp"] as? Date else {
            print("CoreData Error:", "Could not get timestamp")
            return nil
        }
        if let intensity = dict["intensity"] as? Int16 {
            let newBowel = Bowel(context: context)
            newBowel.timestamp = timestamp
            newBowel.date = timestamp.string(withFormat: Constants.DateFormat.Normal)
            newBowel.intensity = intensity
            return newBowel
        }
        
        return nil
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
