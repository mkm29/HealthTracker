//
//  HealthTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/24/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
import UIKit
import CoreData

class HealthTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables to be overridden
    
//    enum HealthType: String {
//        case Cath = "Cath"
//        case Medication = "Medication"
//        case Bowel = "Bowel"
//        case Physician = "Physician"
//        case Note = "Note"
//        case Order = "Order"
//        case Supply = "Supply"
//    }
    var cellIdentifier: String { fatalError("cellIdentifier must be overridden") }
    var entityType: Constants.EntityType { fatalError("entity must be overridden") }
    var entity : String { return entityType.rawValue }
    var sortDescriptors : [NSSortDescriptor]? { return nil }
    var cacheName : String? { return nil }
    var sectionNameKeyPath : String? { return nil }
    var fetchPredicate : NSPredicate? {
        didSet {
            fetchedResultsController.fetchRequest.predicate = fetchPredicate
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = fetchPredicate
        
        fetchRequest.sortDescriptors = sortDescriptors
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
        managedObjectContext: (AppDelegate.getAppDelegate()).persistentContainer.viewContext,
        sectionNameKeyPath: sectionNameKeyPath,
        cacheName: nil)
        aFetchedResultsController.delegate = self
        
        do {
            //print(fetchedResultsController.fetchRequest)
            try aFetchedResultsController.performFetch()
        } catch let error {
            AppDelegate.getAppDelegate().showAlert("Error", error.localizedDescription)
        }
        
        return aFetchedResultsController
    }()
    
    func fetch() {
        do {
            //print(fetchedResultsController.fetchRequest)
            try fetchedResultsController.performFetch()
        } catch let error {
            AppDelegate.getAppDelegate().showAlert("Error", error.localizedDescription)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let sections = fetchedResultsController.sections?.count, let objects = fetchedResultsController.fetchedObjects?.count, objects > 0 {
            numOfSections = sections
        }
        else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No data found. Add some!"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            configureCell(cell, at: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionHeader: String = ""
        if sectionNameKeyPath != nil {
            if let sections = fetchedResultsController.sections {
                switch entityType {
                case .Cath, .Bowel, .Note:
                    sectionHeader = sections[section].name.convertDate()
                default:
                    sectionHeader = sections[section].name
                }
            } else {
                return "Default Section"
            }
        }
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = newIndexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            print("...")
        }
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch entityType {
        case .Cath:
            configureCathCell(cell as! CathCell, cath: fetchedResultsController.object(at: indexPath) as! Cath)
        case .Bowel:
            configureBowelCell(cell, bowel: fetchedResultsController.object(at: indexPath) as! Bowel)
        case .Medication:
            configureMedicationCell(cell as! MedicationCell, medication: fetchedResultsController.object(at: indexPath) as! Medication)
        case .Note:
            configreNoteCell(cell, note: fetchedResultsController.object(at: indexPath) as! Note)
        case .Order:
            configureOrderCell(cell, order: fetchedResultsController.object(at: indexPath) as! Order)
        case .Physician:
            configurePhysicianCell(cell, physician: fetchedResultsController.object(at: indexPath) as! Physician)
        case .Supply:
            configureSupplyCell(cell, supply: fetchedResultsController.object(at: indexPath) as! Supply)
        }
    }
    
    private func configureCathCell(_ cell: CathCell, cath: Cath) {
        cell.amountLabel.text = "\(cath.amount)"
        cell.timeLabel.text = cath.timestamp?.string(withFormat: Constants.DateFormat.Time)
    }
    
    private func configureBowelCell(_ cell: UITableViewCell, bowel: Bowel) {
        cell.textLabel?.text = bowel.timestamp?.string(withFormat: Constants.DateFormat.DayMonthTime)
        cell.detailTextLabel?.text = bowel.type
    }
    
    private func configureMedicationCell(_ cell: MedicationCell, medication: Medication) {
        cell.nameLabel.text = medication.name
        
        // 300mg, 3 times daily
        cell.dosageLabel.text = "\(medication.dosage)mg, \(medication.frequency) times daily"
        cell.remainingLabel.text = "\(medication.remaining) left"
        cell.imageView1.image = UIImage(named: medication.name!)
    }
    
    private func configreNoteCell(_ cell: UITableViewCell, note: Note) {
        cell.textLabel?.text = note.title
        // detail test shouldl be the first n (say 30) characters of body, split by word
        if let bodyWords = note.body?.components(separatedBy: " ") {
            // calculate how much we will splice
            if 5 < bodyWords.count {
                cell.detailTextLabel?.text = bodyWords[0...4].joined(separator: " ")
            } else {
                cell.detailTextLabel?.text = bodyWords.joined(separator: " ")
            }
            
        }
    }
    
    private func configureOrderCell(_ cell: UITableViewCell, order: Order) {
        cell.textLabel?.text = order.summary
        cell.detailTextLabel?.text = "$\(order.price)"
    }
    
    
    private func configurePhysicianCell(_ cell: UITableViewCell, physician: Physician) {
        if let fname = physician.givenName, let lname = physician.familyName {
            cell.textLabel?.text = "\(fname) \(lname)"
        } else {
            cell.textLabel?.text = ""
        }
        cell.detailTextLabel?.text = physician.specialty
    }
    
    
    private func configureSupplyCell(_ cell: UITableViewCell, supply: Supply) {
        cell.textLabel?.text = supply.name
        cell.detailTextLabel?.text = supply.type
    }
    
}
