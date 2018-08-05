//
//  AddAppointmentVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/27/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class AddAppointmentVC: AddEntityVC, EKCalendarChooserDelegate {

    override var entityType: Constants.EntityType { return Constants.EntityType.Appointment }
    
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickExisting(_ sender: Any) {
        let eventStore = EKEventStore()
        
        let calendar = eventStore.defaultCalendarForNewEvents
        let eventChoose = EKEventViewController()
        let vc = EKEventViewController.init()
        
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            guard error == nil else {
                AppDelegate.getAppDelegate().showAlert("Error", error!.localizedDescription)
                return
            }
            if granted {
                print("granted")
                let calendarVC = EKCalendarChooser(selectionStyle: .single, displayStyle: EKCalendarChooserDisplayStyle.allCalendars, eventStore: eventStore)
                calendarVC.delegate = self
                self.present(calendarVC, animated: true, completion: nil)
            }
        }
    }
    
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        print(calendarChooser)
    }

}
