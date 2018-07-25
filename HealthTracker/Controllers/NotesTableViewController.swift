//
//  NotesTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: HealthTableViewController, HealthMenu {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    // MARK: - Variables to overide
    override var entityType: Constants.EntityType { return .Note }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"createdAt", ascending: false)] }
    
    override func viewDidLoad() {
        setupReveal()
    }
    
    func setupFetchedResultsController() {
        
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") {
            if let note = fetchedResultsController.object(at: indexPath) as? Note {
                cell.textLabel?.text = note.title
            }
            return cell
        }
        return UITableViewCell()
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
