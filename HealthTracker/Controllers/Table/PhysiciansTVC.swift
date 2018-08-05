//
//  PhysiciansTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class PhysiciansTVC: HealthTVC, HealthMenu {

    override var cellIdentifier: String { return Constants.CellIdentifiers.Physician.rawValue }
    override var entityType: Constants.EntityType { return .Physician }
    override var sectionNameKeyPath: String? { return "specialty" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"specialty", ascending: true), NSSortDescriptor(key: "familyName", ascending: true)] }

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        setupReveal()
        fetch()
    }

    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }

}