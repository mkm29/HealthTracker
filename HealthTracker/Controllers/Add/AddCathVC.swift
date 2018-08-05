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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //dateTextField.text = getDateString()
        amountTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        amountTextField.becomeFirstResponder()
    }
    

    
    @IBAction func save(_ sender: Any) {
        // validate
        
        guard let amountString = amountTextField.text.nilIfEmpty else {
            AppDelegate.getAppDelegate().showAlert("Oops!", "You must enter an amount")
            return
        }
        
        var cathDict = [String : Any]()
        cathDict["date"] = Date().string(withFormat: Constants.DateFormat.Normal)
        cathDict["timestamp"] = Date() //.toFormat(Constants.DateFormat.Long)
        cathDict["amount"] = Int16((amountString as NSString).integerValue)
        
        addEntity(fromDict: cathDict)
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
