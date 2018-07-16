//
//  UrinateTableViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class UrinateTableViewController: UITableViewController {
    
    let coordinator = Coordinator.shared
    
    enum TableSection	: Int {
        case Monday = 0, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, total
    }
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 25   // Data variable to track our sorted data.
    var data = [TableSection: [Urinate]]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        computeMonthRange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coordinator.getUrinate()
        tableView.reloadData()
    }
    
    private func computeMonthRange() {
        // return a Range from the first Urinate.date to the last
        if let firstDate = coordinator.bladder.first?.date, let lastDate = coordinator.bladder.last?.date {
            let calendar = Calendar.current
            let firstMonth = calendar.component(.month, from: firstDate as Date)
            let lastMonth = calendar.component(.month, from: lastDate as Date)
            let year = calendar.component(.year, from: firstDate as Date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = Constants.DateFormat.Short //"MM-dd-yyyy"
            
            let months = firstMonth...lastMonth
            //print(months)
            for month in months {
                if let days = getDaysIn(monthInt: month, inYear: year) {
                    for day in days {
                        print(formatter.string(from: day))
                    }
                }
            }
        }
        
    }
    
    func getDaysIn(monthInt month: Int, inYear year: Int) -> [Date]? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        if let date = formatter.date(from: "\(month)-01-\(year)") {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: date)
            let startOfMonth = calendar.date(from:components)!
            let numberOfDays = calendar.range(of: .day, in: .month, for: startOfMonth)!.upperBound
            let allDays = Array(0..<numberOfDays).map{ calendar.date(byAdding:.day, value: $0, to: startOfMonth)!}
            return allDays
        }
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coordinator.bladder.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UrinateCell", for: indexPath) as? UrinateCell {
            let urinate = coordinator.bladder[indexPath.row]
            cell.dateLabel.text = urinate.dateString()// urinate.dateString(dateStyle: .medium, timeStyle: .none)
            cell.timeLabel.text = urinate.timeString(timeStyle: .short)
            cell.amountLabel.text = "\(urinate.amount)"
            //cell.detailTextLabel?.text = "\(urinate.amount)"
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            coordinator.removeItem(ofType: .Urinate, withIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func getCurrentDateString(withFormat format: String = "MM-dd-yyyy HH:mm") -> String {
        // this is the format we want -> MM-dd-yyyy HH:mm
        // 2018-07-12T01:54:50+0000
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = format
        // store this date in core data
        let date = Date()
        
        // after fetching date from core data decode it as so
        return dateFmt.string(from: date)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
