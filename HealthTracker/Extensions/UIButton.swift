//
//  UIButton.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

extension UIButton {
    
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
