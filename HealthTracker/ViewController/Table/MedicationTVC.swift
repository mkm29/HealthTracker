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
    override var addViewControllerIdentifier: String { return "AddMedicationVC" }
    override var entityType: Constants.EntityType { return .Medication }
    override var sectionNameKeyPath: String? { return "purpose" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"purpose", ascending: true), NSSortDescriptor(key: "name", ascending: true)] }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        // add Add bar button
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
//        navigationItem.rightBarButtonItem = addButton
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MedicationDetailVC") as! MedicationDetailVC
        detailVC.selectedObject = fetchedResultsController?.object(at: indexPath) as! Medication
        let nvc = UINavigationController(rootViewController: detailVC)
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
