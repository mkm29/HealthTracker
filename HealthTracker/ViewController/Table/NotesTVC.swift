//
//  NotesTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class NotesTVC: HealthTVC {
    
    // MARK: - Variables to overide
    override var cellIdentifier: String { return Constants.CellIdentifiers.Note.rawValue }
    override var addViewControllerIdentifier: String { return "AddNoteVC" }
    override var entityType: Constants.EntityType { return .Note }
    override var sectionNameKeyPath: String? { return "date" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false)] }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CathDetailNVC") as! UINavigationController
        let detailVC = nvc.viewControllers.first as! BowelDetailVC
        let bowel = fetchedResultsController?.object(at: indexPath) as! Bowel
        detailVC.selectedObject = bowel
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
