//
//  Coordinator.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/13/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData


class Coordinator {
    
    var documentsDirectory: String {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
    }
    
    static let shared = Coordinator()
    
    var coreDataManager: CoreDataManager!
    var firebase: FirebaseClient!
    
    
    init() {
        coreDataManager = CoreDataManager()
        firebase = FirebaseClient()
        
        //print(coreDataManager.applicationsDocumentDirectory)
    }
    
    func addObject(_ type: Constants.EntityType, data: [String:Any]) {
        // 1 - Create in Core Data
        // 2. Mirror on Firebase Firestore
        switch type {
        case .Cath:
            let newCath = coreDataManager.createNewObject(ofType: .Cath, objectDictionary: data) as! Cath
            let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Cath.rawValue.lowercased(), data: data)
            newCath.documentID = newFirebase?.documentID
        case .Bowel:
            let newBowel = coreDataManager.createNewObject(ofType: .Bowel, objectDictionary: data) as! Bowel
            let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Bowel.rawValue.lowercased(), data: data)
            newBowel.documentID = newFirebase?.documentID
        case .Medication:
            let newMedication = coreDataManager.createNewObject(ofType: .Medication, objectDictionary: data) as! Medication
            let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Medication.rawValue.lowercased(), data: data)
            newMedication.documentID = newFirebase?.documentID
        default:
            break
        }
        
        // 3. Save Context
        coreDataManager.saveContext()
        
    }
    
}
