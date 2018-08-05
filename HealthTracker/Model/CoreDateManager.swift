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
    
    private func newCath(fromDict dict: [String : Any]) -> Cath? {
        guard let datestring = dict["date"] as? String,
            let timestamp = dict["timestamp"] as? Date,
            let amount = dict["amount"] as? Int16 else {
            print("error: unable to get all data from dictionary")
            return nil
        }
        let newCath = Cath(context: context)
        newCath.date = datestring
        newCath.timestamp = timestamp
        newCath.amount = amount
        return newCath
    }
    
    private func newMedication(fromDictionary dict: [String : Any]) -> Medication? {
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
        if let imagePath = dict["imagePath"] as? String {
            newMedication.imagePath = imagePath
        }
        return newMedication
    }
    
    private func newBowel(fromDict dict: [String:Any]) -> Bowel? {
        guard let timestamp = dict["timestamp"] as? NSDate, let date = dict["date"] as? String, let intensity = dict["intensity"] as? Int16 else {
            print("Error: unable to get all data from dictionary")
            return nil
        }
        
        let newBowel = Bowel(context: context)
        newBowel.timestamp = timestamp as Date
        newBowel.date = date
        newBowel.intensity = intensity
        return newBowel
    }
    
    private func newPysician(fromDict dict: [String:Any]) -> Physician? {
        guard let givenName = dict["givenName"] as? String,
            let familyName = dict["familyName"] as? String,
            let specialty = dict["specialty"] as? String else {
            AppDelegate.getAppDelegate().showAlert("Error", "There was an issue creating new Physician object: unable to parse data.")
            return nil
        }

        let newPhysician = Physician(context: context)
        newPhysician.givenName = givenName
        newPhysician.familyName = familyName
        newPhysician.specialty = specialty
        
        if let medicalEducation = dict["medicalEducation"] as? String {
            newPhysician.medicalEducation = medicalEducation
        }
        
        if let contactIdentifier = dict["contactIdentifier"] as? String {
            newPhysician.contactIdentifier = contactIdentifier
        }

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
