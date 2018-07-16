//
//  NewMedicationViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class NewMedicationViewController: UIViewController {
    
    let coordinator = Coordinator.shared

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var purposeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text.nilIfEmpty,
            let dosage = dosageTextField.text.nilIfEmpty,
            let frequency = frequencyTextField.text.nilIfEmpty,
            let purpose = purposeTextField.text.nilIfEmpty else {
                print("All fields must be completed.")
                return
        }
        let medicationDict: [String:Any] = ["name" : name, "dosage" : Int(dosage), "frequency" : Int(frequency), "purpose" : purpose, "date" : datePicker.date]
        coordinator.newObject(ofType: .Medication, objectDict: medicationDict)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
