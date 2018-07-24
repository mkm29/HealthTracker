//
//  BackTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/19/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class BackTableViewController: UITableViewController {
    
    let MenuItems = ["cath history", "medications", "bowel movements", "physicians", "notes", "orders", "supplies", "settings", "logout"]
    let ReusableIdentifiers = ["CathCell", "MedicationsCell", "BowelCell", "PhysiciansCell", "NotesCell", "OrdersCell", "SuppliesCell", "SettingsCell", "LogoutCell"]
    let MenuImageNames = ["urine-collection", "pill-bottle", "toilet-paper", "doctor", "notes", "orders", "supplies", "settings", "logout"]

    override func viewDidLoad() {
        //TableArray = ["cath schedule", "medications", "bowel movements", "physicians"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath)
//
//        // Configure the cell...
//        cell.textLabel?.text = TableArray[indexPath.row]
//
//        return cell
        
        if let menuCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifiers[indexPath.row]) as? MenuCell {
            
            menuCell.title.text = MenuItems[indexPath.row]
            menuCell.menuImage.image = UIImage(named: MenuImageNames[indexPath.row])
            return menuCell
        }
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;
    }

}
