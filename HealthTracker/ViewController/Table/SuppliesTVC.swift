//
//  SuppliesTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class SuppliesTVC: HealthTVC {
    
    // MARK: - Variables to overide
    override var cellIdentifier: String { return Constants.CellIdentifiers.Supply.rawValue }
    override var addViewControllerIdentifier: String { return "AddSupplyVC" }
    override var entityType: Constants.EntityType { return .Supply }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"name", ascending: true)] }    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
