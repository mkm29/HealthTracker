//
//  OrdersTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class OrdersTableViewController: HealthTableViewController, HealthMenu {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    // MARK: - Variables to overide
    override var entityType: Constants.EntityType { return .Order }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false)] }
    
    override func viewDidLoad() {
        setupReveal()
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell"), let order = fetchedResultsController.object(at: indexPath) as? Order {
            cell.textLabel?.text = order.summary
            cell.detailTextLabel?.text = order.date
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

}
