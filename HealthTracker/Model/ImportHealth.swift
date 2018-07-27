//
//  ImportHealth.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData


class ImportHealth {
    
    // MARK: - Import
    
    class func importCath() {
        // if let path = Bundle.main.path(forResource: "shoes", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        if let path = Bundle.main.path(forResource: "cath", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let cathDict = json as? [[String : Any]] {
                    let appDelegate = AppDelegate.getAppDelegate()
                    
                    for cath in cathDict {
                        // create new Cath object
                        if let dateString = cath["date"] as? String,
                            let amount = cath["amount"] as? Int16,
                            let time = cath["time"] as? String,
                            let timestamp = "\(dateString) \(time)".date() {
                            
                            let newCath = Cath(context: appDelegate.persistentContainer.viewContext)
                            newCath.date = dateString
                            newCath.amount = amount
                            // concatenate date and time
                            newCath.timestamp = timestamp
                            
                        }
                    }
                    appDelegate.saveContext()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    class func importMedication() {
        if let path = Bundle.main.path(forResource: "medication", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let medicationDict = json as? [[String:Any]] {
                    let appDelegate = AppDelegate.getAppDelegate()
                    
                    for medDict in medicationDict {
                        if let name = medDict["name"] as? String,
                            let dosage = medDict["dosage"] as? Int,
                            let freq = medDict["frequency"] as? Int,
                            let purpose = medDict["purpose"] as? String {
                            let newMedication = Medication(context: appDelegate.persistentContainer.viewContext)
                            newMedication.name = name
                            newMedication.dosage = Int16(dosage)
                            newMedication.frequency = Int16(freq)
                            newMedication.purpose = purpose
                            newMedication.remaining = 0
                        }
                    }
                    appDelegate.saveContext()
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    class func importBowel() {
        if let path = Bundle.main.path(forResource: "bm", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let bmDict = json as? [[String:String]] {
                    let appDelegate = AppDelegate.getAppDelegate()
                    
                    for dict in bmDict {
                        if let date = dict["date"], let time = dict["time"], let type = dict["type"], let timestamp = "\(date) \(time)".date() {
                            let newBowel = Bowel(context: appDelegate.persistentContainer.viewContext)
                            newBowel.date = date
                            newBowel.timestamp = timestamp
                            newBowel.type = type
                        }
                    }
                    
                    appDelegate.saveContext()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
