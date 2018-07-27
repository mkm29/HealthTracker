//
//  Extensions.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/14/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

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
    
    func convertDate(f_ format1: String = "MM-dd-yyyy", _ format2: String = "EEEE MMM d") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format1
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format2
        return dateFormatter.string(from: date!)
    }
    
}

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

extension UITextField {
    
    func addBottomBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        self.borderStyle = .none
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    
}
