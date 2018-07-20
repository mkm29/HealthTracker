//
//  BowelTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/19/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class BowelTableViewController: UITableViewController, HealthTVC {
    
    var coordinator: Coordinator! = Coordinator.shared

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupReveal()
        coordinator.fetch(type: .Bowel)
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        if let sections = coordinator.bowelFRC.sections?.count {
//            return sections
//        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let rows = coordinator.bowelFRC.fetchedObjects?.count {
            return rows
        } else {
            return 1
        }
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let sections = coordinator.bowelFRC.sections {
//            return sections[section].name
//        } else {
//            return "Nothing here!"
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BowelCell") {
            let bm = coordinator.bowelFRC.object(at: indexPath)
            cell.textLabel?.text = bm.timestamp?.string(withFormat: Constants.DateFormat.DayMonthTime)
            cell.detailTextLabel?.text = bm.type
            return cell
        }
        return UITableViewCell()
    }

}
