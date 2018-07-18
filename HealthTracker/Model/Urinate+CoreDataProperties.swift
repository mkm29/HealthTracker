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
    @NSManaged public var date: String
    @NSManaged public var timestamp: Date
    
    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: timestamp)
    }

}
