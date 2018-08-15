//
//  CathDetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class CathDetailVC: DetailVC, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.delegate = self

        // Disable the save button until something is changed
        saveButton.isEnabled = false
        if let cath = selectedObject as? Cath {
            datePicker.date = cath.timestamp!
            amount.text = "\(cath.amount)"
        }
        datePicker.addTarget(self, action: #selector(enableSave), for: .valueChanged)
    }
    
    @objc func enableSave() {
        saveButton.isEnabled = true
    }
    

    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if let cath = selectedObject as? Cath {
            // update Cath
            cath.timestamp = datePicker.date
            cath.date = datePicker.date.string(withFormat: Constants.DateFormat.Normal)
            if let amountString = amount.text as NSString? {
                cath.amount = Int16(amountString.intValue)
            }
            coordinator.coreDataManager.saveContext()
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
    }

}
