//
//  MedicationTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class MedicationTableViewController: HealthTableViewController, HealthMenu  {
    
    override var entityType: Constants.EntityType { return .Medication }
    override var sectionNameKeyPath: String? { return "purpose" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"purpose", ascending: true), NSSortDescriptor(key: "name", ascending: true)] }

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        setupReveal()
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as? MedicationCell, let medication = fetchedResultsController.object(at: indexPath) as? Medication {
            // Configure the cell...
            
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
