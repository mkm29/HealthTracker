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

    let coreDataManager = CoreDataManager()
    
    
    // FetchedResultControllers
    var cathFRC: NSFetchedResultsController<Cath>!
    var medicationFRC: NSFetchedResultsController<Medication>!
    var bowelFRC: NSFetchedResultsController<Bowel>!
    var physicianFRV: NSFetchedResultsController<Physician>!
    var appointmentsFRC: NSFetchedResultsController<Appointment>!
    
    
    init() {
        //setupFetchedResultsControllers()
        //fetchCath()
        //fetchMedication()
    }
    
    func setupFetchedResultsControllers() {
        setupCathFRC()
        setupMedicationFRC()
    }
    
    private func setupCathFRC() {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Cath> = Cath.fetchRequest()
        
        // Add Sort Descriptors
        let sort1 = NSSortDescriptor(key: #keyPath(Cath.date), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Cath.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        // Initialize Fetched Results Controller
        cathFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: #keyPath(Cath.date), cacheName: nil)
    }
    
    private func setupMedicationFRC() {
        let request: NSFetchRequest = Medication.fetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(Medication.purpose), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(Medication.name), ascending: true)
        request.sortDescriptors = [sort1, sort2]
        medicationFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: #keyPath(Medication.purpose), cacheName: nil)
    }
    
    func fetchCath() {
        do {
            try cathFRC.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Fetch Urinate")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func fetchMedication() {
        do {
            try medicationFRC.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Fetch Urinate")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    
}
