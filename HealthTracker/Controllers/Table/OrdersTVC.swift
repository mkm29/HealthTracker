//
//  OrdersTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class OrdersTVC: HealthTVC, HealthMenu {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    // MARK: - Variables to overide
    override var cellIdentifier: String { return Constants.CellIdentifiers.Order.rawValue }
    override var entityType: Constants.EntityType { return .Order }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false)] }
    
    override func viewDidLoad() {
        setupReveal()
        fetch()
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

}
