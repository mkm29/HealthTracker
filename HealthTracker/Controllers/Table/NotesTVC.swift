//
//  NotesTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class NotesTVC: HealthTVC, HealthMenu {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    // MARK: - Variables to overide
    override var cellIdentifier: String { return Constants.CellIdentifiers.Note.rawValue }
    override var entityType: Constants.EntityType { return .Note }
    override var sectionNameKeyPath: String? { return "date" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false)] }
    
    override func viewDidLoad() {
        setupReveal()
        fetch()
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNoteDetail" {
            if let navVC = segue.destination as? UINavigationController,
                let detailVC = navVC.viewControllers.first as? NoteDetailVC,
                let indexPath = tableView.indexPathForSelectedRow, let note = fetchedResultsController?.object(at: indexPath) as? Note {
                detailVC.selectedObject = note
            }
        }
    }
}
