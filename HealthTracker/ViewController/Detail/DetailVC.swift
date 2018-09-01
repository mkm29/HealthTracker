//
//  DetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/13/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
import UIKit
import CoreData

class DetailVC: UIViewController {

    var coordinator: Coordinator!
    var selectedObject: NSManagedObject? {
        didSet {
            documentID = selectedObject?.value(forKey: "documentID") as? String
        }
    }
    var documentID: String? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coord = (slideMenuController() as? ExSlideMenuController)?.coordinator else {
            // Go to LoginVC
            self.goToInitialViewController()
            return
        }
        coordinator = coord
        checkAuth(coordinator: coordinator)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissEntityDetail))
    }
    
    func update() {
        guard coordinator.mirrorOnFirebase,
            let object = selectedObject,
            let type = object.entity.managedObjectClassName,
            let documentID = documentID else {
                AppDelegate.getAppDelegate().showAlert("Oops", "Unable to update on Firebase. ")
                return
        }
        
        coordinator.firebase.updateDocument(type, documentID: documentID, newData: CoreDataManager.entityToJSON(object)) { (error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
        }
    }

    @objc func dismissEntityDetail() {
        selectedObject = nil
        slideMenuController()?.closeRight()
    }
    
}
