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
        case Cath
        case Medication
        case Bowel
        case Physician
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
    
    func applicationDocumentsDirectory() -> String {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bartjacobs.Core_Data" in the application's documents Application Support directory.
        //let urls = FileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let path = urls[urls.count-1].absoluteString.replacingOccurrences(of: "%20", with: "\\ ")
        return path
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
        }
        saveContext()
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
        return newMedication
    }
    
    private func newBowel(fromDict dict: [String:Any]) -> Bowel? {
        guard let timestamp = dict["timestamp"] as? NSDate, let date = dict["date"] as? String, let type = dict["type"] as? String else {
            print("Error: unable to get all data from dictionary")
            return nil
        }
        
        let newBowel = Bowel(context: context)
        newBowel.timestamp = timestamp as Date
        newBowel.date = date
        newBowel.type = type
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
    
    
    // TODO: add export functionality
    
    // MARK: - Import
    
    func importCath() {
        // if let path = Bundle.main.path(forResource: "shoes", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        if let path = Bundle.main.path(forResource: "cath", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let cathDict = json as? [[String : Any]] {
                    for cath in cathDict {
                        // create new Cath object
                        if let dateString = cath["date"] as? String,
                            let amount = cath["amount"] as? Int16,
                            let time = cath["time"] as? String,
                            let timestamp = "\(dateString) \(time)".date() {
                            
                            let newCath = Cath(context: context)
                            newCath.date = dateString
                            newCath.amount = amount
                            // concatenate date and time
                            newCath.timestamp = timestamp
                            
                        }
                    }
                    saveContext()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func importMedication() {
        if let path = Bundle.main.path(forResource: "medication", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let medicationDict = json as? [[String:Any]] {
                    for medDict in medicationDict {
                        if let name = medDict["name"] as? String,
                            let dosage = medDict["dosage"] as? Int,
                            let freq = medDict["frequency"] as? Int,
                            let purpose = medDict["purpose"] as? String {
                            let newMedication = Medication(context: context)
                            newMedication.name = name
                            newMedication.dosage = Int16(dosage)
                            newMedication.frequency = Int16(freq)
                            newMedication.purpose = purpose
                            newMedication.remaining = 0
                        }
                    }
                    saveContext()
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func importBowel() {
        if let path = Bundle.main.path(forResource: "bm", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let bmDict = json as? [[String:String]] {
                    for dict in bmDict {
                        if let date = dict["date"], let time = dict["time"], let type = dict["type"], let timestamp = "\(date) \(time)".date() {
                            let newBowel = Bowel(context: context)
                            newBowel.date = date
                            newBowel.timestamp = timestamp
                            newBowel.type = type
                        }
                    }
                    saveContext()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}
