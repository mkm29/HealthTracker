//
//  AddEntityVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddEntityVC: UIViewController {
    
    var coordinator = Coordinator.shared
    var entityType: Constants.EntityType { fatalError("entity must be overridden") }
    
    override func viewWillAppear(_ animated: Bool) {
        if !coordinator.isAuthenticated {
            coordinator.showLoginVC(fromVC: self)
        }
    }

    func addEntity(fromDict dict: [String:Any]) -> Any? {
         return coordinator.addObject(entityType, data: dict)
    }

}
