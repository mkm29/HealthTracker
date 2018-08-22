//
//  OrdersTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class OrdersTVC: HealthTVC {
    
    // MARK: - Variables to overide
    override var cellIdentifier: String { return Constants.CellIdentifiers.Order.rawValue }
    override var entityType: Constants.EntityType { return .Order }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false)] }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

}
