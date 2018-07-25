//
//  SuppliesTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class SuppliesTableViewController: HealthTableViewController, HealthMenu {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    // MARK: - Variables to overide
    override var entityType: Constants.EntityType { return .Supply }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"name", ascending: true)] }
    
    override func viewDidLoad() {
        setupReveal()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SupplyCell"), let supply = fetchedResultsController.object(at: indexPath) as? Supply {
            cell.textLabel?.text = supply.name
            cell.detailTextLabel?.text = supply.type
        }
        return UITableViewCell()
    }

    
    // HealthMenu protocol methods
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
