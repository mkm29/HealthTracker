//
//  EntityViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/28/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import CoreData

class EntityViewController: UIViewController {
    
    var coordinator: Coordinator!
    var entity: NSManagedObject?
    var entityType: Constants.EntityType { fatalError("entity must be overridden") }
    var isNewEntity: Bool { return false }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coord = (slideMenuController() as? ExSlideMenuController)?.coordinator else {
            // Go to LoginVC
            self.goToInitialViewController()
            return
        }
        coordinator = coord
        checkAuth(coordinator: coordinator)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissEntity))
    }
    
    
    func addEntity(fromDict dict: [String:Any]) -> NSManagedObject? {
        guard let coordinator = (slideMenuController() as? ExSlideMenuController)?.coordinator else {
            AppDelegate.getAppDelegate().showAlert("Error", "Unable to access app coordinator, please log out and log back in.")
            return nil
        }
        entity = coordinator.addObject(entityType, data: dict)
        return entity
    }
    
    func updateEntity() -> NSManagedObject? {
        if let entity = entity {
            // save the object
            coordinator.coreDataManager.saveContext()
            // update in Firebase as well
            if coordinator.mirrorOnFirebase {
                let documentID = entity.value(forKey: "documentID")
                print("TODO: Update object on Firebase via the documentID: \(String(describing: documentID))")
            }
            return entity
        }
        return nil
    }
    
    @objc func dismissEntity() {
        entity = nil
        slideMenuController()?.closeRight()
        view.endEditing(true)
    }

}
