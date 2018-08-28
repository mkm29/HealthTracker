//
//  SettingsVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var coordinator: Coordinator?
    
    var presentingVC: UIViewController!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var givenName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mirrorOnFirebase: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        guard let sliderMenu = slideMenuController() as? ExSlideMenuController else {
            self.goToInitialViewController()
            return
        }
        coordinator = sliderMenu.coordinator
        checkAuth(coordinator: coordinator)
        setNavigationBarItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
    }

    @IBAction func importFromFirebase(_ sender: Any) {
        // prompt the user what he/she wants to import
    }
    
    
    @IBAction func linkWithFacebook(_ sender: Any) {
        
    }
    
    @IBAction func linkWithGoogle(_ sender: Any) {
        
    }
    
    
    @IBAction func linkWithTwitter(_ sender: Any) {
        
    }
    
    
    @IBAction func linkWithAmazon(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        print("Save settings and dismiss")
        
        slideMenuController()?.changeMainViewController(presentingVC, close: true)
    }
}
