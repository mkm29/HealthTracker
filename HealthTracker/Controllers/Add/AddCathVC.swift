//
//  NewUrinateViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddCathVC: AddEntityVC, SetDateProtocol {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Cath }

    @IBOutlet weak var amountTextField: UITextField!
    var setDate: Date?
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        //dateTextField.text = getDateString()
        amountTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        amountTextField.becomeFirstResponder()
    }
    
    @IBAction func setDateButtonTapped(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setDateTimeViewController") as! SetDateTimeVC
        controller.setDateProtocol = self
        controller.preferredContentSize = CGSize(width: view.frame.width-50, height: view.frame.height/2)
        controller.view.layer.cornerRadius = 10
        controller.view.layer.borderColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0).cgColor
        controller.view.layer.borderWidth = 1.5
        showPopup(controller, sourceView: addButton)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    
    @IBAction func save(_ sender: Any) {
        // validate
        
        guard let amountString = amountTextField.text.nilIfEmpty else {
            AppDelegate.getAppDelegate().showAlert("Oops!", "You must enter an amount")
            return
        }
        
        var cathDict = [String : Any]()
        
        if let date = setDate {
            cathDict["date"] = date.string(withFormat: Constants.DateFormat.Normal)
            cathDict["timestamp"] = date
        } else {
            cathDict["date"] = Date().string(withFormat: Constants.DateFormat.Normal)
            cathDict["timestamp"] = Date()
        }
        
        cathDict["amount"] = Int16((amountString as NSString).integerValue)
        
        _ = addEntity(fromDict: cathDict)
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setDate(date: Date) {
        setDate = date
    }

}
