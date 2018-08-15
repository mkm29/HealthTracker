//
//  NewMedicationViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddMedicationVC: AddEntityVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override var entityType: Constants.EntityType { return Constants.EntityType.Medication }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var purposeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isPrescription: UISwitch!
    @IBOutlet weak var isActive: UISwitch!
    
    let imagePicker = UIImagePickerController()
    var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setImagePickerSource(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        nameTextField.becomeFirstResponder()
        //nameTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        //purposeTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        dosageTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        frequencyTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
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
    

    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text.nilIfEmpty,
            let dosage = dosageTextField.text.nilIfEmpty,
            let frequency = frequencyTextField.text.nilIfEmpty,
            let purpose = purposeTextField.text.nilIfEmpty else {
                print("All fields must be completed.")
                return
        }
        var medicationDict: [String:Any] = ["name" : name,
                                            "dosage" : Int16(dosage) ?? 0,
                                            "frequency" : Int16(frequency) ?? 0,
                                            "purpose" : purpose,
                                            "prescription" : isPrescription.isOn,
                                            "active" : isActive.isOn]
        if let medImage = imageView.image,
            let imagePath = medImage.saveImage(withPrefix: "medication_\(name)") {
            medicationDict["imagePath"] = imagePath
        }
        
        addEntity(fromDict: medicationDict)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func saveImage(_ image: UIImage, tag: String) -> String? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentsPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(String(tag)).png", isDirectory: false)

        var path: String? = nil
        
        // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsPath)
            
            for file in files {
                // If we find existing image delete it to make room for the new once
                if "\(documentsPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        
        
        do {
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: filePath, options: .atomic)
                path = filePath.path
            }
        } catch {
            print("Could not write image data: \(error)")
        }
        return path
    }

}
