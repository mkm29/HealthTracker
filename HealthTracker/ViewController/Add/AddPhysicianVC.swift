//
//  ContactsViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import ContactsUI

class AddPhysicianVC: AddEntityVC, UITextFieldDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Physician }
    
    var selectedContact: CNContact? {
        didSet {
            firstName.text = selectedContact?.givenName
            lastName.text = selectedContact?.familyName
        }
    }

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var specialty: UITextField!
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var addPhysicianButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstName.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        lastName.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        specialty.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        education.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        
        addPhysicianButton.roundBottom(withRadius: 20)
        //AppDelegate.getAppDelegate().contactsStore
        
    }

    @IBAction func pickContact(_ sender: Any) {
        // make sure you have permissions
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
        contactPickerViewController.delegate = self
        
        requestContactsAccess { (granted) in
            if granted {
                self.present(contactPickerViewController, animated: true, completion: nil)
            }
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        selectedContact = contact
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let givenName = firstName.text, let familyName = lastName.text else {
            AppDelegate.getAppDelegate().showAlert("Error", "Complete first and last name(s) and try again.")
            return
        }
        var dict: [String:Any] = ["givenName" : givenName, "familyName" : familyName]

        dict["specialty"] = specialty.text.nilIfEmpty
        dict["medicalEducation"] = education.text.nilIfEmpty
        
        if let selectedContact = selectedContact {
            dict["contactIdentifier"] = selectedContact.identifier
        }
        
        _ = addEntity(fromDict: dict)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Contacts
    func requestContactsAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let contactsStore = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            contactsStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
}
