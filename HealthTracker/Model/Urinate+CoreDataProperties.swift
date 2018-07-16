//
//  Urinate+CoreDataProperties.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/12/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
//

import Foundation
import CoreData


extension Urinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Urinate> {
        return NSFetchRequest<Urinate>(entityName: "Urinate")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var date: NSDate?
    
    func timeString(timeStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = timeStyle
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date as! Date)
    }
    
    func dateString() -> String {
        // EEE MMM d yyyy
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date as! Date)
    }

}
