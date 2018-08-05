//
//  NewBowelViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
import UIKit

class AddBowelVC: AddEntityVC {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Bowel }

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var manualTime: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var setDateButton: UIButton!
    
    var setTime = false
    
    let types: [String] = ["small", "normal", "large"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        addButton.roundBottom(withRadius: Constants.Design.cornerRadius)
        setDateButton.round(radius: 10.0, corners: CACornerMask.layerMaxXMinYCorner)
        manualTime.addBorder(type: .Top, color: Constants.Colors.Blue, withWidth: 1.0)
        manualTime.text = Date().string(withFormat: Constants.DateFormat.Long)
        slider.isContinuous = false
    }
    
    @IBAction func setTimeManual(_ sender: Any) {
        setTime = true
    }

    
    @IBAction func save(_ sender: Any) {
        var date: Date!
        if setTime, let dateString = manualTime.text.nilIfEmpty {
            date = dateString.date()
        } else {
            date = Date()
        }

        let dict: [String:Any] = ["date" : date.string(withFormat: Constants.DateFormat.Normal),
                                  "timestamp" : date,
                                  "intensity" : Int16(slider.value)]
        addEntity(fromDict: dict)

        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
