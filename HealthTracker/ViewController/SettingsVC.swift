//
//  SettingsVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var coordinator: Coordinator!
    
    var presentingVC: UIViewController!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var givenName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mirrorOnFirebase: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        navigationItem.title = "Settings"
        
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let sliderMenu = slideMenuController() as? ExSlideMenuController else {
            self.goToInitialViewController()
            return
        }
        coordinator = sliderMenu.coordinator
        checkAuth(coordinator: coordinator)
    }

    @IBAction func importFromFirebase(_ sender: Any) {
        
        // prompt the user what he/she wants to import
        let actionSheet = UIAlertController(title: "Import", message: "What data would you like to import from Firebase?", preferredStyle: .actionSheet)
        let importCathAction = UIAlertAction(title: "Cath Schedule", style: .default) { (action) in
            self.coordinator.importFromFirebase(entity: .Cath)
        }
        let importMedication = UIAlertAction(title: "Medication", style: .default) { (action) in
            self.coordinator.importFromFirebase(entity: .Medication)
        }
        let importBowel = UIAlertAction(title: "Bowel Movements", style: .default) { (action) in
            self.coordinator.importFromFirebase(entity: .Bowel)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(importCathAction)
        actionSheet.addAction(importBowel)
        actionSheet.addAction(importMedication)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
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
        slideMenuController()?.changeMainViewController(presentingVC, close: true)
    }
}
