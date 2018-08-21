//
//  Date.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import Foundation

extension Date {
    
    func toFormat(_ format: String) -> Date? {
        // 1. get date string from self
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        // 2.
        return formatter.date(from: dateString)
    }
    
    func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
