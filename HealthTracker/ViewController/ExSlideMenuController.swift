//
//  ExSlideMenuController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/11/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController : SlideMenuController {
    
    var coordinator: Coordinator?

    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is MainVC ||
            vc is CathTVC ||
            vc is BowelTVC ||
            vc is MedicationTVC {
                return true
            }
        }
        return false
    }
    
    override func track(_ trackAction: TrackAction) {
//        switch trackAction {
//        case .leftTapOpen:
//            print("TrackAction: left tap open.")
//        case .leftTapClose:
//            print("TrackAction: left tap close.")
//        case .leftFlickOpen:
//            print("TrackAction: left flick open.")
//        case .leftFlickClose:
//            print("TrackAction: left flick close.")
//        case .rightTapOpen:
//            print("TrackAction: right tap open.")
//        case .rightTapClose:
//            print("TrackAction: right tap close.")
//        case .rightFlickOpen:
//            print("TrackAction: right flick open.")
//        case .rightFlickClose:
//            print("TrackAction: right flick close.")
//        }   
    }
}
