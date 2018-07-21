//
//  Extensions.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/14/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}


extension String {
    
    func date(withFormat format: String = Constants.DateFormat.Long) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func dateFromTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.Time
        return formatter.date(from: self)
    }
    
}

extension Date {
    
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.Time
        return formatter.string(from:self)
    }
    
    func dayMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.DayMonth
        return formatter.string(from: self)
    }
    
    func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

extension UIViewController {
    
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
