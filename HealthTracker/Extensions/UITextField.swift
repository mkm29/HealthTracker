//
//  UITextField.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

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
