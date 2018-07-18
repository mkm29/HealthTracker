//
//  Importer.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/16/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData
import UIKit

class Importer {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func importSchedule() {
        // if let path = Bundle.main.path(forResource: "shoes", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        if let path = Bundle.main.path(forResource: "schedule", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let urinateDict = json as? [[String : Any]] {
                    //print("converted to dict")
                    for urinate in urinateDict {
                        if let date = urinate["date"] as? String,
                            let amount = urinate["amount"] as? Int,
                            let time = urinate["time"] as? String {
                            //print("got info now creating Urinate object")
                            let newUrinate = Urinate(context: context)
                            // need to create Date object and then get MM-dd-yyyy as date and HH:mm as time
                            // now extract the 2 components - a date and a time string
                            newUrinate.date = date
                            newUrinate.time = time
                            newUrinate.amount = Int16(amount)
                        } else {
                            print("did not get info...")
                        }
                    }
                    appDelegate.saveContext()
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
                    appDelegate.saveContext()
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func dateFromString(dateString: String) -> Date? {
        let formatter = DateFormatter()
        // are we getting the date or just the time?
        formatter.locale = Locale(identifier: Constants.DateFormat.Locale)
        formatter.dateFormat = Constants.DateFormat.Long
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    private func getTimeString(fromDate date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.DateFormat.Locale)
        formatter.dateFormat = Constants.DateFormat.Time
        return formatter.string(from:date)
    }
    
    
}
