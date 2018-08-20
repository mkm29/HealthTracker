//
//  Coordinator.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/13/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData
import Firebase
import LocalAuthentication
import UIKit

class Coordinator {
    
    var documentsDirectory: String {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
    }
    
    static let shared = Coordinator()
    
    var isAuthenticated = false
    
    var coreDataManager: CoreDataManager!
    var firebase: FirebaseClient!
    
    
    init() {
        coreDataManager = CoreDataManager()
        firebase = FirebaseClient()
    }
    
    func login(completionHandler: @escaping (_ status: Bool) -> Void) {
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                AppDelegate.getAppDelegate().showAlert("Auth Error", laError.localizedDescription)
                return
            }
            
            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                if (laContext.biometryType == LABiometryType.faceID) {
                    localizedReason = "Unlock using Face ID"
                    //print("FaceId support")
                } else if (laContext.biometryType == LABiometryType.touchID) {
                    localizedReason = "Unlock using Touch ID"
                    //print("TouchId support")
                } else {
                    print("No Biometric support")
                    AppDelegate.getAppDelegate().showAlert("Auth Error", "FaceId not supported")
                }
            } else {
                // Fallback on earlier versions
                AppDelegate.getAppDelegate().showAlert("Error", "Unhandled error")
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            // need to add a delay
                            // 1. Fade out Anonymous image
                            Coordinator.shared.isAuthenticated = true
                            completionHandler(true)
                        } else {
                            print("failure")
                            completionHandler(false)
                        }
                    }
                    
                })
            })
        } else {
            var errMessage = ""
            if error != nil {
                errMessage = error!.localizedDescription
            }
            if let err = error?.localizedDescription {
                AppDelegate.getAppDelegate().showAlert("Auth Error", "Can't evaluate policy: \(err)")
            } else {
                errMessage = "Can't evaluate policy"
            }
            AppDelegate.getAppDelegate().showAlert("FaceId Error", errMessage)
            completionHandler(false)
        }
    }
    
    func showLoginVC(fromVC: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? HomeVC {
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
        case .Physician:
            let newPhysician = coreDataManager.createNewObject(ofType: .Physician, objectDictionary: data) as! Physician
            let newFirebase = firebase.addDocument(ofType: Constants.EntityType.Physician.rawValue.lowercased(), data: data)
            newPhysician.documentID = newFirebase?.documentID
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
            }
            self.coreDataManager.saveContext()
        }
    }
    
    private func convertDict(snapshot: [String:Any]) -> [String:Any] {
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
