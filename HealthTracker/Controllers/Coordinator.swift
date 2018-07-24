//
//  Coordinator.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData
import Contacts

class Coordinator {
    
    enum HealthType {
        case Cath
        case Medication
        case Bowel
        case Physician
    }
    
    static let shared = Coordinator()
    
    let appDelegate = AppDelegate.getAppDelegate()
    let coreDataManager = CoreDataManager()
    
    let contactsStore = CNContactStore()
    
    // State (bool) variables
    var hasContactsPermissions = false
    var hasNotificationsPermissions = false
    var isAuthenticated = false
    
    // FetchedResultControllers
    var cathFRC: NSFetchedResultsController<Cath>!
    var medicationFRC: NSFetchedResultsController<Medication>!
    var bowelFRC: NSFetchedResultsController<Bowel>!
    var physicianFRC: NSFetchedResultsController<Physician>!
    var appointmentsFRC: NSFetchedResultsController<Appointment>!
    
    
    init() {
        setupFetchedResultsControllers()
    }
    
    func requestContactsAccess() {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            hasContactsPermissions = true
            
        case .denied, .notDetermined:
            self.contactsStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    self.hasContactsPermissions = true
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async {
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.appDelegate.showAlert("Contacts Error", message)
                        }
                    }
                }
            })
            
        default:
            hasContactsPermissions = false
        }
    }
    
    func requestNotificationsPermissions() {
        // I do not want/need remote notifications...just local
        //UIApplication.shared.registerForRemoteNotifications() // you can also set here for local notification.
    }
    
    func setupFetchedResultsControllers() {
        setupCathFRC()
        setupMedicationFRC()
        setupBowelFRC()
        setupPhysiciansFRC()
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
    
    private func setupBowelFRC() {
        let request: NSFetchRequest<Bowel> = Bowel.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Bowel.date), ascending: false)
        request.sortDescriptors = [sort]
        bowelFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupPhysiciansFRC() {
        let request: NSFetchRequest<Physician> = Physician.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Physician.familyName), ascending: true)
        request.sortDescriptors = [sort]
        physicianFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // Generic fetch function for any FRC
    func fetch(type frcType: HealthType) {
        
        switch frcType {
        case .Cath:
            try! cathFRC.performFetch()
        case .Medication:
            try! medicationFRC.performFetch()
        case .Bowel:
            try! bowelFRC.performFetch()
        case .Physician:
            try! physicianFRC.performFetch()
        }
    }
    
    
}
