//
//  MedicationDetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

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
            
            if let imagePath = medication.imagePath {
                print("Has imagePath, try to open and set")
                imageView.image = UIImage(contentsOfFile: imagePath)
            }
            if imageView.image == nil {
                print("could not open local file, downloading")
                if let pillboxURL = medication.pillboxImageURL, let url = URL(string: pillboxURL) {
                    // add the following logic to UIImage/View extension
                    // 1. download image from URL
                    imageView.downloadAndSetImage(fromURL: url) { (error) in
                        guard error == nil else {
                            AppDelegate.getAppDelegate().showAlert("Error", error!.localizedDescription)
                            return
                        }
                    }
                }
            }
            
        } else {
            navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @IBAction func save(_ sender: Any) {
        guard let coordinator = coordinator else {
            AppDelegate.getAppDelegate().showAlert("Error", "Unable to access application data, logout and log back in.")
            return
        }
        guard let medication = selectedObject as? Medication, let name = medication.name else {
            print("No medication. Should handle in viewDidLoad")
            return
        }
        // has anything changed?
        let changed = hasChanged()
        
        if !changed {
            AppDelegate.getAppDelegate().showAlert("Oops", "Nothing was changed for this medication!")
            return
        }
        // 1. something has changed so update it
        medication.name = name
        medication.purpose = (purpose.text.nilIfEmpty != nil) ? purpose.text! : medication.purpose
        medication.dosage = (dosage.text.nilIfEmpty != nil) ? Int16(dosage.text!)! : medication.dosage
        medication.frequency = (frequency.text.nilIfEmpty != nil) ? Int16(frequency.text!)! : medication.frequency
        medication.prescription = isPrescription.isOn
        medication.active = isActive.isOn
        
        // handle image...if not local save it and set imagePath
        //medication.imagePath = imageView.image?.saveImage(withPrefix: medication.name!)
        medication.imagePath = imageView.image?.store(name: name)
        // 2. save Medication
        coordinator.coreDataManager.saveContext()
        
        // 3. dismiss
        dismissAddEntity()
    }
    
    // save image and return filePath
    
    private func hasChanged() -> Bool {
        // going to need an array of Bools for each field
        var changed: [String:Bool] = ["name" : false, "purpose" : false, "dosage" : false, "frequency" : false, "prescription" : false, "active" : false]
        guard let medication = selectedObject as? Medication else {
            return false
        }
        if let name = name.text.nilIfEmpty {
            changed["name"] = (name != medication.name!) ? true : false
        }
        if let purpose = purpose.text.nilIfEmpty, let medPurpose = medication.purpose {
            changed["purpose"] = (purpose != medPurpose) ? true : false
        }
        if let dosageString = dosage.text.nilIfEmpty {
            changed["dosage"] = (Int16(dosageString) != medication.dosage) ? true : false
        }
        if let freqString = frequency.text.nilIfEmpty {
            changed["frequency"] = (Int16(freqString) != medication.frequency) ? true : false
        }
        if medication.imagePath == nil && imageView.image != nil {
            changed["image"] = true
        }
        changed["prescription"] = isPrescription.isOn
        changed["active"] = isActive.isOn
        
        for (_, value) in changed {
            if value { return true }
        }
        return false
    }

}
