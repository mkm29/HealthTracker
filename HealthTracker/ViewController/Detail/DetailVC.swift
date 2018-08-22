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
        if let sliderMenu = slideMenuController() as? ExSlideMenuController {
            coordinator = sliderMenu.coordinator
        }
        self.checkAuth(coordinator: coordinator)
    }

}
