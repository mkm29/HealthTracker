//
//  BowelTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/19/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class BowelTVC: HealthTVC {
    
    override var cellIdentifier: String { return Constants.CellIdentifiers.Bowel.rawValue }
    override var entityType: Constants.EntityType { return .Bowel }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false), NSSortDescriptor(key: "timestamp", ascending: false)] }
    override var sectionNameKeyPath: String? { return "date" }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBowelDetail" {
            guard let navVC = segue.destination as? UINavigationController,
                let detailVC = navVC.viewControllers.first as? BowelDetailVC,
                let indexPath = tableView.indexPathForSelectedRow,
                let bowel = fetchedResultsController?.object(at: indexPath) as? Bowel else {
                AppDelegate.getAppDelegate().showAlert("Error", "There was an error retrieving the object!")
                return
            }
            detailVC.selectedObject = bowel
        }
    }

}
