//
//  ImportHealth.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData


class ImportHealth {
    
    let appDelegate = AppDelegate.getAppDelegate()
    let coreData = CoreDataManager()
    let firebase = FirebaseClient()
    // MARK: - Import
    
    func importCath() {
        // if let path = Bundle.main.path(forResource: "shoes", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        print("Starting import")
        if let path = Bundle.main.path(forResource: "cath", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            print("file exists")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("serialzes JSON")
                if let cathDict = json as? [[String : Any]] {
                    
                    for cath in cathDict {
                        if let date = cath["date"] as? String,
                            let time = cath["time"] as? String,
                            let timestamp = "\(date) \(time)".date(withFormat: Constants.DateFormat.Long) {
                            var newDict = cath
                            newDict["timestamp"] = timestamp
                            if let newCath = coreData.createNewObject(ofType: .Cath, objectDictionary: newDict) as? Cath {
                                print("Created Cath")
                                //let firebaseCath = firebase.addDocument(Consants, data: newDict)
                                //newCath.documentID = firebaseCath?.documentID
                            }
                        }
                    }
                    coreData.saveContext()
                } else {
                    print("unable to serialize JSON")
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("file does not exist")
        }
    }
    
    func importMedication() {
        if let path = Bundle.main.path(forResource: "medication", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let medicationDict = json as? [[String:Any]] {
                    let appDelegate = AppDelegate.getAppDelegate()
                    
                    for medDict in medicationDict {
                        let newMedication = coreData.createNewObject(ofType: .Medication, objectDictionary: medDict) as! Medication
                        //let firebaseMed = firebase.addDocument(.medication, data: medDict)
                        //newMedication.documentID = firebaseMed?.documentID
                    }
                    coreData.saveContext()
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func importBowel() {
        print("Starting import")
        if let path = Bundle.main.path(forResource: "bowel", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            print("file exists")
            do {
                print("serialzes JSON")
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let jsonDict = json as? [[String:Any]] {
                    for dict in jsonDict {
                        if let date = dict["date"] as? String,
                            let time = dict["time"] as? String,
                            let timestamp = "\(date) \(time)".date(withFormat: Constants.DateFormat.Long) {
                            var newDict = dict
                            newDict["timestamp"] = timestamp
                            if let newBowel = coreData.createNewObject(ofType: .Bowel, objectDictionary: newDict) as? Bowel {
                                print("createn Bowel")
                                //let firebaseBowel = firebase.addDocument(.bowel, data: newDict)
                                //newBowel.documentID = firebaseBowel?.documentID
                            } else {
                                print("unable to create Bowel")
                            }
                            
                        }
                    }
                }

                coreData.saveContext()
                print("Done")
                
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("file not found")
        }
    }
    
}
