//
//  UrinateTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class CathTVC: HealthTVC {
    
    override var cellIdentifier: String { return Constants.CellIdentifiers.Cath.rawValue }
    override var entityType: Constants.EntityType { return .Cath }
    override var sectionNameKeyPath: String? { return "date" }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false), NSSortDescriptor(key: "timestamp", ascending: false)] }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCath))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @objc func addCath() {
        let addCathVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCathVC") as! AddCathVC
        let nvc = UINavigationController(rootViewController: addCathVC)
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cathDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CathDetailVC") as! CathDetailVC
        let cath = fetchedResultsController?.object(at: indexPath) as! Cath
        cathDetailVC.selectedObject = cath
        let nvc = UINavigationController(rootViewController: cathDetailVC)
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
