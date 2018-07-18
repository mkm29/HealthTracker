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
    var bladderFRC: NSFetchedResultsController<Urinate>!
    var medicationFRC: NSFetchedResultsController<Medication>!
    var bowelFRC: NSFetchedResultsController<Bowel>!
    var physicianFRV: NSFetchedResultsController<Physician>!
    var appointmentsFRC: NSFetchedResultsController<Appointment>!
    
    
    init() {
        //
        //print(coreDataManager.applicationDocumentsDirectory().absoluteString)
        setupFetchedResultsControllers()
        // see if we need to import
        if bladderFRC.fetchedObjects?.count == 0 {
            Importer().importSchedule()
        }
        if medicationFRC.fetchedObjects?.count == 0 {
            Importer().importMedication()
        }
    }
    
    func setupFetchedResultsControllers() {
        setupAndFetchBladderFRC()
        setupAndFetchMedicationFRC()
    }
    
    private func setupAndFetchBladderFRC() {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Urinate> = Urinate.fetchRequest()
        
        // Add Sort Descriptors
        let sort1 = NSSortDescriptor(key: #keyPath(Urinate.date), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Urinate.time), ascending: false)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        // Initialize Fetched Results Controller
        bladderFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: #keyPath(Urinate.date), cacheName: nil)
        try! bladderFRC.performFetch()
    }
    
    private func setupAndFetchMedicationFRC() {
        let request: NSFetchRequest = Medication.fetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(Medication.purpose), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(Medication.name), ascending: true)
        request.sortDescriptors = [sort1, sort2]
        medicationFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: #keyPath(Medication.purpose), cacheName: nil)
        try! bladderFRC.performFetch()
    }
    
    
}
