//
//  Coordinator.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData


class Coordinator {
    
    enum HealthType {
        case Urinate
        case Medication
    }
    
    static let shared = Coordinator()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var bladder: [Urinate] = [Urinate]()
    var medication: [Medication] = [Medication]()
    var bowel: [Bowel] = [Bowel]()
    var doctors: [Physician] = [Physician]()
    var appointments: [Appointment] = [Appointment]()
    
    init() {
        //
        printApplicationSupportDirectory()
        getUrinate()
        getMedication()
        
        
        if bladder.count == 0 {
            importSchedule()
        }
        if medication.count == 0 {
            importMedication()
        }
    }
    
    func saveContext () {
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
    
    func newObject(ofType type: HealthType, objectDict: [String: Any]) {
        switch type {
        case .Urinate:
            if let newUrinate = newUrinateObject(fromDict: objectDict) {
                bladder.append(newUrinate)
            }
        case .Medication:
            if let newMedication = newMedication(fromDict: objectDict) {
                medication.append(newMedication)
            }
        }
        saveContext()
    }
    
    private func printApplicationSupportDirectory() {
        if let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print(dir)
        }
    }
    
    private func newUrinateObject(fromDict dict: [String : Any]) -> Urinate? {
        guard let date = dict["date"] as? Date, let amount = dict["amount"] as? Int else {
            print("Unable to extract data from dict")
            return nil
        }
        let newUrinate = Urinate(context: context)
        newUrinate.date = date as! NSDate
        newUrinate.amount = Int16(amount)
        return newUrinate
    }
    
    func getUrinate() {
        let request: NSFetchRequest<Urinate> = Urinate.fetchRequest()
        // need to sort by date
        let sort = NSSortDescriptor(key: #keyPath(Urinate.date), ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            bladder = result
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getMedication() {
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Medication.name), ascending: true)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            medication = result
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func newMedication(fromDict dict: [String:Any]) -> Medication? {
        // [String:Any] = ["name" : name, "dosage" : Int(dosage), "frequency" : Int(frequency), "purpose" : purpose, "date" : datePicker.date]
        guard let name = dict["name"] as? String,
            let dosage = dict["dosage"] as? Int,
            let frequency = dict["frequency"] as? Int,
            let purpose = dict["purpose"] as? String else {
                print("unable to extract all data from dict")
                return nil
        }
        let newMedication = Medication(context: context)
        newMedication.name = name
        newMedication.dosage = Int16(dosage)
        newMedication.frequency = Int16(frequency)
        newMedication.purpose = purpose
        
        // need to find/create new Filled object
        // TODO
        
        return newMedication
    }
    
    private func newFilled(fromDict dict: [String:Any]) -> Filled? {
        
        
        return nil
    }
    
    func removeItem(ofType type: HealthType, withIndex index: Int) {
        var object: NSManagedObject
        switch type {
        case .Urinate:
            print("Remove urinate object")
            object = bladder[index]
        case .Medication:
            print("Remove medication")
            object = medication[index]
        }
        // delete from context
        context.delete(object)
        saveContext()
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.Long //"MM-dd-yyyy hh:mm a"
        formatter.locale = Locale(identifier: Constants.DateFormat.Long)
        return formatter.date(from: dateString)
    }
    
    func importSchedule() {
        // if let path = Bundle.main.path(forResource: "shoes", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        if let path = Bundle.main.path(forResource: "schedule", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let urinateDict = json as? [[String : Any]] {
                    print("converted to dict")
                    for urinate in urinateDict {
                        if let datetime = urinate["date"] as? String,
                            let amount = urinate["amount"] as? Int,
                            let date = dateFromString(datetime) {
                            let newUrinate = Urinate(context: context)
                            newUrinate.date = date as NSDate
                            newUrinate.amount = Int16(amount)
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
    
    
}
