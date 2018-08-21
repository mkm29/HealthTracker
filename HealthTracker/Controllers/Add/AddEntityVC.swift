//
//  AddEntityVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddEntityVC: UIViewController {
    
    var coordinator: Coordinator?
    var entityType: Constants.EntityType { fatalError("entity must be overridden") }
    
    override func viewWillAppear(_ animated: Bool) {
        if let sliderMenu = slideMenuController() as? ExSlideMenuController {
            coordinator = sliderMenu.coordinator
        }
        self.checkAuth(coordinator: coordinator)
    }

    func addEntity(fromDict dict: [String:Any]) -> Any? {
        guard let coordinator = coordinator else {
            AppDelegate.getAppDelegate().showAlert("Error", "Unable to access app coordinator, please log out and log back in.")
            return nil
        }
         return coordinator.addObject(entityType, data: dict)
    }

}
