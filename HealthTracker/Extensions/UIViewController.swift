//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func checkAuth(coordinator: Coordinator?) {
        if let coordinator = coordinator, coordinator.isAuthenticated {
            
        } else {
            // go to rootViewController, need to login
            dismiss(animated: false) {
                self.goToInitialViewController()
            }
        }
    }
    
    func goToInitialViewController() {
        let window = UIApplication.shared.delegate!.window!
        window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }
}
