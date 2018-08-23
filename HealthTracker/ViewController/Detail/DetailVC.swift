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

    var coordinator: Coordinator?
    var selectedObject: NSManagedObject?
    
    override func viewWillAppear(_ animated: Bool) {
        guard let sliderMenu = slideMenuController() as? ExSlideMenuController, let coord = sliderMenu.coordinator else {
            // Go to LoginVC
            self.goToInitialViewController()
            return
        }
        coordinator = coord
        checkAuth(coordinator: coordinator)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddEntity))
    }

    @objc func dismissAddEntity() {
        selectedObject = nil
        slideMenuController()?.closeRight()
    }
    
}
