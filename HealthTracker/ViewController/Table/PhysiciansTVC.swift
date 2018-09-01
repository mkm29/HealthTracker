//
//  PhysiciansTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class PhysiciansTVC: HealthTVC {

    override var cellIdentifier: String { return Constants.CellIdentifiers.Physician.rawValue }
    override var addViewControllerIdentifier: String { return "AddPhysicianVC" }
    override var entityType: Constants.EntityType { return .Physician }
    override var sectionNameKeyPath: String? { return "specialty" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"specialty", ascending: true), NSSortDescriptor(key: "familyName", ascending: true)] }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhysician))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @objc func addPhysician() {
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPhysicianVC") as! AddPhysicianVC
        let nvc = UINavigationController(rootViewController: addVC)
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhysicianDetailVC") as! PhysicianDetailVC
        let physician = fetchedResultsController?.object(at: indexPath) as! Physician
        detailVC.selectedObject = physician
        let nvc = UINavigationController(rootViewController: detailVC)
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

}
