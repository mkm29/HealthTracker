//
//  AddEntityVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddEntityVC: UIViewController {

    var entityType: Constants.EntityType { fatalError("entity must be overridden") }

    func addEntity(fromDict dict: [String:Any]) -> Any? {
        guard let menu = slideMenuController() as? ExSlideMenuController, let coordinator = menu.coordinator else {
            AppDelegate.getAppDelegate().showAlert("Error", "Unable to access app coordinator, please log out and log back in.")
            return nil
        }
        return coordinator.addObject(entityType, data: dict)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let sliderMenu = slideMenuController() as? ExSlideMenuController, let coordinator = sliderMenu.coordinator else {
            // Go to LoginVC
            self.goToInitialViewController()
            return
        }
        checkAuth(coordinator: coordinator)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddEntity))
    }
    
    @objc func dismissAddEntity() {
        slideMenuController()?.closeRight()
    }

}
