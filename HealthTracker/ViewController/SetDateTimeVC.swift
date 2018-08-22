//
//  SetDateTimeVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/15/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

protocol SetDateProtocol {
    func setDate(date: Date)
}

class SetDateTimeVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var setDateProtocol: SetDateProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        datePicker.date = Date()
    }

    @IBAction func setDate(_ sender: Any) {
        setDateProtocol?.setDate(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}
