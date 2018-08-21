//
//  AddNoteViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddNoteVC: AddEntityVC, UITextViewDelegate {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Note }

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        titleTextField.becomeFirstResponder()
        bodyTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    

    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let noteTtitle = titleTextField.text.nilIfEmpty, let noteBody = bodyTextView.text.nilIfEmpty else {
            AppDelegate.getAppDelegate().showAlert("Oops", "Sorry both fields must be complete")
            return
        }
        let newNote: [String:String] = ["title" : noteTtitle,
                                        "body" : noteBody]
        _ = addEntity(fromDict: newNote)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
