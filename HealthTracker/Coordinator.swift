//
//  Coordinator.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/13/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData
import Firebase
//import UIKit
//import Contacts

class Coordinator {
    
    var documentsDirectory: String {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
    }
    
    var isAuthenticated = false
    var mirrorOnFirebase: Bool = true
    var coreDataManager: CoreDataManager!
    var firebase: FirebaseClient!
    
    init() {
        coreDataManager = CoreDataManager()
        firebase = FirebaseClient()
    }
    
    func showLoginVC(fromVC: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            fromVC.dismiss(animated: true) {
                fromVC.present(loginVC, animated: true, completion: nil)
            }
            //fromVC.show(loginVC, sender: nil)
        }
    }
    
    
    func addObject(_ type: Constants.EntityType, data: [String:Any]) {
        // 1 - Create in Core Data
        // 2. Mirror on Firebase Firestore
        switch type {
        case .Cath:
            let newCath = coreDataManager.createNewObject(ofType: .Cath, objectDictionary: data) as! Cath
            if mirrorOnFirebase {
                let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Cath.rawValue.lowercased(), data: data)
                newCath.documentID = newFirebase?.documentID
            }
        case .Bowel:
            let newBowel = coreDataManager.createNewObject(ofType: .Bowel, objectDictionary: data) as! Bowel
            if mirrorOnFirebase {
                let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Bowel.rawValue.lowercased(), data: data)
                newBowel.documentID = newFirebase?.documentID
            }
            
        case .Medication:
            let newMedication = coreDataManager.createNewObject(ofType: .Medication, objectDictionary: data) as! Medication
            if mirrorOnFirebase {
                let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Medication.rawValue.lowercased(), data: data)
                newMedication.documentID = newFirebase?.documentID
            }
        case .Physician:
            let newPhysician = coreDataManager.createNewObject(ofType: .Physician, objectDictionary: data) as! Physician
            if mirrorOnFirebase {
                let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Physician.rawValue.lowercased(), data: data)
                newPhysician.documentID = newFirebase?.documentID
            }
        default:
            break
        }
        
        // 3. Save Context
        coreDataManager.saveContext()
        
    }
    
    func importAllFromFirebase() {
        importFromFirebase(entity: .Bowel)
        importFromFirebase(entity: .Cath)
        importFromFirebase(entity: .Medication)
    }
    
    func importFromFirebase(entity: Constants.EntityType) {
        firebase.getDocuments(forType: entity) { (result, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            if let result = result {
                for snapshot in result {
                    // need to convert dictionary to one suitable for creating Core Data objects
                    _ = self.coreDataManager.createNewObject(ofType: entity, objectDictionary: self.convertDict(snapshot: snapshot))
                    
                }
                self.coreDataManager.saveContext()
            }
            
        }
    }
    
    func convertDict(snapshot: [String:Any]) -> [String:Any] {
        var dict = [String:Any]()
        
        if let timestamp = snapshot["timestamp"] as? Timestamp {
            let date = timestamp.dateValue()
            let dateShort = date.string(withFormat: Constants.DateFormat.Normal)
            let time = date.string(withFormat: Constants.DateFormat.Time)
            dict["timestamp"] = date
            dict["date"] = dateShort
            dict["time"] = time
        }
        if let documentID = snapshot["documentID"] as? String {
            dict["documentID"] = documentID
        }
        if let amount = snapshot["amount"] as? Int16 {
            dict["amount"] = amount
        }
        if let intensity = snapshot["intensity"] as? Int16 {
            dict["intensity"] = intensity
        }
        // Medication
        if let active = snapshot["active"] as? Bool {
            dict["active"] = active
        }
        if let dosage = snapshot["dosage"] as? Int16 {
            dict["dosage"] = dosage
        }
        if let frequency = snapshot["frequency"] as? Int16 {
            dict["frequency"] = frequency
        }
        if let name = snapshot["name"] as? String {
            dict["name"] = name
        }
        if let pillboxImageURL = snapshot["pillboxImageURL"] as? String {
            dict["pillboxImageURL"] = pillboxImageURL
        }
        if let prescription = snapshot["prescription"] as? Bool {
            dict["prescription"] = prescription
        }
        if let purpose = snapshot["purpose"] as? String {
            dict["purpose"] = purpose
        }
        
        return dict
    }
    

    
}
