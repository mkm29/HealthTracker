//
//  BowelDetailVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class BowelDetailVC: DetailVC {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        smallLabel.sizeToFit()
        largeLabel.sizeToFit()
        // Do any additional setup after loading the view.
        if let bowel = selectedObject as? Bowel {
            datePicker.date = bowel.timestamp!
            slider.value = Float(bowel.intensity)
        }
    }

    @IBAction func save(_ sender: Any) {
        if let bowel = selectedObject as? Bowel {
            bowel.timestamp = datePicker.date
            bowel.date = datePicker.date.string(withFormat: Constants.DateFormat.Normal)
            bowel.intensity = Int16(slider.value)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
