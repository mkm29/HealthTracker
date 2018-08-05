//
//  UrinateTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class CathTVC: HealthTVC, HealthMenu {
    
    override var cellIdentifier: String { return Constants.CellIdentifiers.Cath.rawValue }
    override var entityType: Constants.EntityType { return .Cath }
    override var sectionNameKeyPath: String? { return "date" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false), NSSortDescriptor(key: "timestamp", ascending: false)] }
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        setupReveal()

    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCathDetail" {
            guard let navVC = segue.destination as? UINavigationController, let detailVC = navVC.viewControllers.first as? CathDetailVC, let indexPath = tableView.indexPathForSelectedRow else {
                AppDelegate.getAppDelegate().showAlert("Oops", "Cath object could not be found...")
                return
            }
            detailVC.cath = fetchedResultsController.object(at: indexPath) as? Cath
        }
    }

}
