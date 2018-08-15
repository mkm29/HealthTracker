//
//  NewUrinateViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddCathVC: AddEntityVC {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Cath }

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var setDateView: UIView!
    @IBOutlet weak var setDateTextfield: UITextField!
    
    var setDate = false
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        //dateTextField.text = getDateString()
        amountTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        amountTextField.becomeFirstResponder()
        
        setDateView.layer.cornerRadius = 10.0
        setDateView.layer.borderColor = UIColor.darkGray.cgColor
        setDateView.layer.borderWidth = 1.5
    }
    @IBAction func setTime(_ sender: Any) {
        view.addSubview(setDateView)
        setDateView.center = view.center
    }
    
    @IBAction func setDateTime(_ sender: Any) {
        setDate = true
        setDateView.removeFromSuperview()
    }
    
    
    @IBAction func save(_ sender: Any) {
        // validate
        
        guard let amountString = amountTextField.text.nilIfEmpty else {
            AppDelegate.getAppDelegate().showAlert("Oops!", "You must enter an amount")
            return
        }
        
        var cathDict = [String : Any]()
        
        if setDate {
            if let dateString = setDateTextfield.text.nilIfEmpty {
                cathDict["date"] = dateString.date(withFormat: Constants.DateFormat.Normal)
                cathDict["timestamp"] = dateString.date(withFormat: Constants.DateFormat.Long)
            }
        } else {
            cathDict["date"] = Date().string(withFormat: Constants.DateFormat.Normal)
            cathDict["timestamp"] = Date()
        }
        
        
        cathDict["amount"] = Int16((amountString as NSString).integerValue)
        
        _ = addEntity(fromDict: cathDict)
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
