//
//  Constants.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/15/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
import UIKit

struct Constants {
    
    struct DateFormat  {
        static let DayMonth = "EEEE MMM d"
        static let DayMonthTime = "EEEE MMM d hh:mm a"
        static let Locale = "en_US"
        static let Short = "MM-dd"
        static let Normal = "MM-dd-yyyy"
        static let Long = "MM-dd-yyyy hh:mm a"
        static let Time = "hh:mm a"
    }
    
    enum EntityType: String {
        case Appointment = "Appointment"
        case Cath = "Cath"
        case Medication = "Medication"
        case Bowel = "Bowel"
        case Physician = "Physician"
        case Note = "Note"
        case Order = "Order"
        case Supply = "Supply"
    }
    
    enum CellIdentifiers: String {
        case Cath = "CathCell"
        case Bowel = "BowelCell"
        case Medication = "MedicationCell"
        case Note = "NoteCell"
        case Order = "OrderCell"
        case Physician = "PhysicianCell"
        case Supply = "SupplyCell"
    }
    
    struct Design {
        static let cornerRadius: CGFloat = 10.0
    }
    
    struct Colors {
        static let Blue = UIColor(red: 0.0235, green: 0.502, blue: 0.9765, alpha: 1.0)
    }
    
    static let BowelType: [Int16 : String] = [1 : "small",
                                              2: "small",
                                              3: "medium-small",
                                              4: "medium-small",
                                              5: "normal",
                                              6: "normal",
                                              7: "large",
                                              8: "large",
                                              9: "very large",
                                              10: "very large"]
    
}
