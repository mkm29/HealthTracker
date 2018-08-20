//
//  DetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/13/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import CoreData

class DetailVC: UIViewController {

    var coordinator = Coordinator.shared
    
    var selectedObject: NSManagedObject?
    
    override func viewWillAppear(_ animated: Bool) {
        if !coordinator.isAuthenticated {
            coordinator.showLoginVC(fromVC: self)
        }
    }

}
