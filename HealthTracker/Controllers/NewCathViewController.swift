//
//  NewUrinateViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class NewCathViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //dateTextField.text = getDateString()
        amountTextField.addBottomBorder()
        amountTextField.becomeFirstResponder()
    }
    

    
    @IBAction func save(_ sender: Any) {
        // validate
        
        guard let amountString = amountTextField.text.nilIfEmpty else {
            showAlert()
            return
        }
        
        var cathDict = [String : Any]()
        cathDict["date"] = Date().string(withFormat: Constants.DateFormat.Normal)
        cathDict["timestamp"] = Date().toFormat(Constants.DateFormat.Long)
        cathDict["amount"] = Int16((amountString as NSString).integerValue)
        
        //print(cathDict)
        _ = CoreDataManager.shared.createNewObject(ofType: .Cath, objectDictionary: cathDict)
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    private func showAlert() {
        // must enter amount
        let alertController = UIAlertController(title: "oops!", message:
            "You must enter an amount", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
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
