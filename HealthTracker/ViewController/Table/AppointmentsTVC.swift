//
//  SuppliesTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AppointmentsTVC: HealthTVC {
    
    // MARK: - Variables to overide
    override var cellIdentifier: String { return Constants.CellIdentifiers.Appointment.rawValue }
    override var entityType: Constants.EntityType { return .Appointment }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"timestampt", ascending: false)] }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }
}
