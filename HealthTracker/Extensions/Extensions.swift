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
    
    enum BorderType {
        case Left
        case Top
        case Bottom
        case Right
    }
    
    func addBorder(type: BorderType, color: UIColor, withWidth: Double) {
        let border = CALayer()
        border.borderColor = color.cgColor
        let width = CGFloat(withWidth)
        border.borderWidth = width
        self.borderStyle = .none
        
        var borderFrame: CGRect!
        
        switch type {
        case .Bottom:
            borderFrame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        case .Top:
            borderFrame = CGRect(x: 0, y: 0 + width, width: self.frame.size.width, height: width)
        case .Left:
            borderFrame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            borderFrame = CGRect(x: self.frame.size.width, y: 0, width: width, height: self.frame.size.height)
        }
        border.frame = borderFrame
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

extension UIButton {
    
//    func roundBottomCorners() {
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.frame
//        rectShape.position = self.center
//        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        self.layer.backgroundColor = UIColor.green.cgColor
//        //Here I'm masking the textView's layer with rectShape layer
//        self.layer.mask = rectShape
//    }
    
//    func roundBottom(cornerRadius: Int = 10) {
//        self.clipsToBounds = true
//        self.layer.cornerRadius = CGFloat(cornerRadius) // 10
//        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        let tes = [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner]
//        self.layer.maskedCorners = tes
//    }
    func round(radius: CGFloat, corners: CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func roundTop(withRadius radius: CGFloat = Constants.Design.cornerRadius) {
        self.round(radius: radius, corners: [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner])
    }
    
    func roundBottom(withRadius radius: CGFloat = Constants.Design.cornerRadius) {
        self.round(radius: radius, corners: [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner])
    }
    
    func roundRight(withRadius radius: CGFloat = Constants.Design.cornerRadius) {
        self.round(radius: radius, corners: [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMaxXMaxYCorner])
    }

    
    
}
