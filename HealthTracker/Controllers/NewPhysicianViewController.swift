//
//  ContactsViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import ContactsUI

class NewPhysicianViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    let coordinator = Coordinator.shared
    
    var selectedContact: CNContact? {
        didSet {
            firstName.text = selectedContact?.givenName
            lastName.text = selectedContact?.familyName
        }
    }

    @IBOutlet weak var chooseContact: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var specialty: UITextField!
    @IBOutlet weak var education: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !coordinator.hasContactsPermissions {
            // disable choose contacts button
            coordinator.requestContactsAccess()
            //chooseContact.isEnabled = false
        }

        // Do any additional setup after loading the view.
        firstName.addBottomBorder()
        lastName.addBottomBorder()
        specialty.addBottomBorder()
        education.addBottomBorder()
        
        //AppDelegate.getAppDelegate().contactsStore
        
    }

    @IBAction func pickContact(_ sender: Any) {
        if !coordinator.hasContactsPermissions {
            coordinator.requestContactsAccess()
        }
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
        contactPickerViewController.delegate = self
        present(contactPickerViewController, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        selectedContact = contact
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newPhysician(_ sender: Any) {
        
        guard let givenName = firstName.text, let familyName = lastName.text else {
            AppDelegate.getAppDelegate().showAlert("Error", "Complete first and last name(s) and try again.")
            return
        }
        var dict: [String:Any] = [String:Any]()
        dict["givenName"] = givenName
        dict["familyName"] = familyName
        
        if let identifier = selectedContact?.identifier {
            dict["identifier"] = identifier
        }
        dict["specialty"] = specialty.text.nilIfEmpty
        dict["eduication"] = education.text.nilIfEmpty
        _ = coordinator.coreDataManager.createNewObject(ofType: .Physician, objectDictionary: dict)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
