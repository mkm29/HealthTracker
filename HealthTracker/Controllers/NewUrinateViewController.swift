//
//  NewUrinateViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class NewUrinateViewController: UIViewController {
    
    let coordinator = Coordinator.shared

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var setDateManual = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //dateTextField.text = getDateString()
    }
    

    
    @IBAction func save(_ sender: Any) {
        // validate
        
        guard let amountString = amountTextField.text.nilIfEmpty else {
            showAlert()
            return
        }
        
        var urinateDict = [String : Any]()
        if setDateManual, let dateString = dateTextField.text {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy hh:mm a"
            urinateDict["date"] = formatter.date(from: dateString) as! NSDate
        } else {
            urinateDict["date"] = NSDate()
        }
        
        urinateDict["amount"] = (amountString as NSString).integerValue
        coordinator.newObject(ofType: .Urinate, objectDict: urinateDict)
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    private func showAlert() {
        // must enter amount
        let alertController = UIAlertController(title: "oops!", message:
            "You must enter an amount", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func setDateManual(_ sender: Any) {
        setDateManual = true
    }
    private func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date())
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
