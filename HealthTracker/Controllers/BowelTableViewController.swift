//
//  BowelTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/19/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData

class BowelTableViewController: HealthTableViewController, HealthMenu {
    
    override var entityType: Constants.EntityType { return .Bowel }
    override var sortDescriptors : [NSSortDescriptor]? { return [NSSortDescriptor(key:"date", ascending: false), NSSortDescriptor(key: "timestamp", ascending: false)] }
    override var sectionNameKeyPath: String? { return "date" }
    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        setupReveal()
    }
    
    func setupReveal() {
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BowelCell"), let bowel = fetchedResultsController.object(at: indexPath) as? Bowel {
            cell.textLabel?.text = bowel.timestamp?.string(withFormat: Constants.DateFormat.DayMonthTime)
            cell.detailTextLabel?.text = bowel.type
            return cell
        }
        return UITableViewCell()
    }

}
