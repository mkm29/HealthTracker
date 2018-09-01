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
    override var addViewControllerIdentifier: String { return "AddBowelVC" }
    override var entityType: Constants.EntityType { return .Bowel }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false), NSSortDescriptor(key: "timestamp", ascending: false)] }
    override var sectionNameKeyPath: String? { return "date" }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bowelDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BowelDetailVC") as! BowelDetailVC
        let bowel = fetchedResultsController?.object(at: indexPath) as! Bowel
        bowelDetailVC.selectedObject = bowel
        let nvc = UINavigationController(rootViewController: bowelDetailVC)
        slideMenuController()?.changeRightViewController(nvc, closeRight: false)
        slideMenuController()?.changeRightViewWidth(view.bounds.width)
        slideMenuController()?.openRight()
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
