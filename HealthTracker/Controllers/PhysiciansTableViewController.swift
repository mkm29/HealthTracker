//
//  PhysiciansTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class PhysiciansTableViewController: HealthTableViewController, HealthMenu {

    override var entityType: Constants.EntityType { return .Physician }
    override var sectionNameKeyPath: String? { return "specialty" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"specialty", ascending: true), NSSortDescriptor(key: "familyName", ascending: true)] }

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        setupReveal()

    }

    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PhysicianCell"), let physician = fetchedResultsController.object(at: indexPath) as? Physician {
            if let fname = physician.givenName, let lname = physician.familyName {
                cell.textLabel?.text = "\(fname) \(lname)"
            } else {
                cell.textLabel?.text = ""
            }
            cell.detailTextLabel?.text = physician.specialty
            return cell
        }
        return UITableViewCell()
    }

}
