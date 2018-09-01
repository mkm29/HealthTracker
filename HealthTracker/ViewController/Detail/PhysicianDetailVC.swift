//
//  PhysicianDetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import ContactsUI

class PhysicianDetailVC: DetailVC, UIPickerViewDelegate, CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedContact: CNContact? {
        didSet {
            givenNameTextField.text = selectedContact?.givenName
            familyNameTextField.text = selectedContact?.familyName
        }
    }
    
    let imagePicker = UIImagePickerController()
    var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var givenNameTextField: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var specialtyTextField: UITextField!
    @IBOutlet weak var medicalEducationTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    
    
    override func viewDidLoad() {
        givenNameTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        familyNameTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        specialtyTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        medicalEducationTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        
        //AppDelegate.getAppDelegate().contactsStore
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setImagePickerSource(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imagePicker.delegate = self
        
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        
        
        if let physician = selectedObject as? Physician {
            guard let givenName = physician.givenName, let familyName = physician.familyName else {
                dismissEntityDetail()
                return
            }
            givenNameTextField.text = givenName
            familyNameTextField.text = familyName
            if let specialty = physician.specialty {
                specialtyTextField.text = specialty
            }
            if let education = physician.medicalEducation {
                medicalEducationTextField.text = education
            }
            
        }
    }
    
    
    @objc func pickImage() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = imagePickerSource
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func setImagePickerSource(tapGestureRecognizer: UITapGestureRecognizer?) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: "Pick Image", message: "How do you want to choose the image?", preferredStyle: .alert)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.imagePickerSource = .camera
            }
            
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                self.imagePickerSource = .photoLibrary
            }
            
            alertController.addAction(cameraAction)
            alertController.addAction(libraryAction)
            present(alertController, animated: true) {
                self.pickImage()
            }
        } else {
            // the camera is not available
            pickImage()
        }
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
    
    @IBAction func save(_ sender: Any) {
        guard let physician = selectedObject as? Physician,
            let givenName = givenNameTextField.text.nilIfEmpty,
            let familyName = familyNameTextField.text.nilIfEmpty else {
            AppDelegate.getAppDelegate().showAlert("Oops", "First and last name are required.")
            return
        }
        physician.givenName = givenName
        physician.familyName = familyName
        physician.specialty = specialtyTextField.text
        physician.medicalEducation = medicalEducationTextField.text
        physician.hospital = hospitalTextField.text
        
        if let imagePath = imageView.image?.store(name: "\(givenName)_\(familyName).png") {
            physician.imagePath = imagePath
        }
        update()
        
        dismissEntityDetail()
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
