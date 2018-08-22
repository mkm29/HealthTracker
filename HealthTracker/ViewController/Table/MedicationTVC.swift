//
//  MedicationTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class MedicationTVC: HealthTVC  {
    
    override var cellIdentifier: String { return Constants.CellIdentifiers.Medication.rawValue }
    override var entityType: Constants.EntityType { return .Medication }
    override var sectionNameKeyPath: String? { return "purpose" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"purpose", ascending: true), NSSortDescriptor(key: "name", ascending: true)] }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMedication",
            let indexPath = tableView.indexPathForSelectedRow,
            let med = fetchedResultsController?.object(at: indexPath) as? Medication {
            let navVC = segue.destination as! UINavigationController
            let medicationDetail = navVC.viewControllers.first as! MedicationDetailVC
            medicationDetail.selectedObject = med
        }
    }

}
