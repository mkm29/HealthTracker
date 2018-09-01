//
//  AddCathViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/29/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddCathViewController: EntityViewController, SetDateProtocol {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Cath }
    override var isNewEntity: Bool { return true }
    var setDate: Date?

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        //dateTextField.text = getDateString()
        amountTextField.addBorder(type: .Bottom, color: UIColor.lightGray, withWidth: 1.0)
        amountTextField.becomeFirstResponder()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddEntity))
    }
    
    @IBAction func setDateButtonTapped(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setDateTimeViewController") as! SetDateTimeVC
        controller.setDateProtocol = self
        controller.preferredContentSize = CGSize(width: view.frame.width-50, height: view.frame.height/2)
        controller.view.layer.cornerRadius = 10
        controller.view.layer.borderColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0).cgColor
        controller.view.layer.borderWidth = 1.5
        self.showPopup(controller, sourceView: addButton)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        present(controller, animated: true)
    }
    
    func setDate(date: Date) {
        setDate = date
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
        dismissEntity()
        
    }

}
