//
//  NoteDetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/26/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class NoteDetailVC: DetailVC, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextArea: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        saveButton.isEnabled = false
        titleTextField.delegate = self
        bodyTextArea.delegate = self
        // Do any additional setup after loading the view.
        if let note = selectedObject as? Note {
            titleTextField.text = note.title.nilIfEmpty
            bodyTextArea.text = note.body.nilIfEmpty
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let coordinator = coordinator else {
            AppDelegate.getAppDelegate().showAlert("Error", "Unable to access application data, logout and log back in.")
            return
        }
        if let note = selectedObject as? Note {
            note.title = titleTextField.text
            note.body = bodyTextArea.text
            coordinator.coreDataManager.saveContext()
        }
        dismissAddEntity()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
    }
}
