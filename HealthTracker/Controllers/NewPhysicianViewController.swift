//
//  NewPhysicianViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class NewPhysicianViewController: UIViewController {

    @IBOutlet weak var physicianName: UITextField!
    @IBOutlet weak var specialty: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        physicianName.becomeFirstResponder()
    }

    @IBAction func newPhysician(_ sender: Any) {
        guard let name = physicianName.text.nilIfEmpty, let specialty = specialty.text.nilIfEmpty else {
            showAlert("Oops", "Sorry all fields must be completed!")
            return
        }
        var dict = [String:String]()
        dict["name"] = name
        dict["specialty"] = specialty
        _ = Coordinator.shared.coreDataManager.createNewObject(ofType: .Physician, objectDictionary: dict)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
