//
//  Constants.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/15/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

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
    
}
