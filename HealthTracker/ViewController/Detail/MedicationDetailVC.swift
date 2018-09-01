//
//  MedicationDetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import MBProgressHUD

class MedicationDetailVC: DetailVC {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var purpose: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dosage: UITextField!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var isPrescription: UISwitch!
    @IBOutlet weak var isActive: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let medication = selectedObject as? Medication {
            // handle save in save function (do not save if nothing has been changed - show alert instead)
            saveButton.isEnabled = true
            // set outlets
            name.text = medication.name!
            purpose.text = (medication.purpose.nilIfEmpty != nil) ? medication.purpose! : ""
            dosage.text = "\(medication.dosage)"
            frequency.text = "\(medication.frequency)"
            
            isPrescription.isOn = medication.prescription
            isActive.isOn = medication.active
            
            
            if let urlString = medication.pillboxImageURL, let url = URL(string: urlString) {
                let progressHUD = MBProgressHUD(view: imageView)
                progressHUD.center = imageView.center
                progressHUD.show(animated: true)
                
                imageView.downloadImage(fromURL: url) { (error) in
                    //progressHUD.hide(animated: true)
                    guard error == nil else {
                        AppDelegate.getAppDelegate().showAlert("Error", "Could not download medication image.")
                        return
                    }
                }
            }
            
        } else {
            navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @IBAction func save(_ sender: Any) {
        
        if let medication = selectedObject as? Medication {
            guard let name = (selectedObject as? Medication)?.name else {
                AppDelegate.getAppDelegate().showAlert("Oops!", "The medication name is required.")
                return
            }
            medication.imagePath = imageView.image?.store(name: name)
            // 2. save Medication
            
            medication.name = name
            medication.purpose = purpose.text.nilIfEmpty
            medication.dosage = Int16(dosage.text.nilIfEmpty ?? "0")!
            medication.frequency = Int16(frequency.text.nilIfEmpty ?? "0")!
            medication.prescription = isPrescription.isOn
            medication.active = isActive.isOn
            coordinator.coreDataManager.saveContext()
            update()
        }
        // 4. dismiss
        dismissEntityDetail()
    }

}
