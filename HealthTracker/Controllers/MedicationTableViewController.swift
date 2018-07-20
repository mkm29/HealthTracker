//
//  MedicationTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class MedicationTableViewController: UITableViewController, HealthTVC {
    
    var coordinator: Coordinator! // = Coordinator.shared

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        coordinator = Coordinator.shared
        setupReveal()
        coordinator.fetch(type: .Medication)
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let sections = coordinator.medicationFRC.sections?.count {
            return sections
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = coordinator.medicationFRC.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = coordinator.medicationFRC.sections {
            return sections[section].name
        } else {
            return "No Medications!"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as? MedicationCell {
            // Configure the cell...
            let medication = coordinator.medicationFRC.object(at: indexPath)
            cell.nameLabel.text = medication.name
            
            // 300mg, 3 times daily
            cell.dosageLabel.text = "\(medication.dosage)mg, \(medication.frequency) times daily"
            cell.remainingLabel.text = "\(medication.remaining) left"
            cell.imageView1.image = UIImage(named: medication.name!)
            return cell
        }
        return UITableViewCell()
    }

}
