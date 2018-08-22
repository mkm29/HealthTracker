//
//  AppDelegate.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import Firebase
//import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showAlert(_ title: String,_ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        if self.window?.rootViewController is UINavigationController {
            let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
            let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
            presentedViewController.present(alertController, animated: true, completion: nil)
        } else {
            // just a UIViewController
            let presentedViewCtonroller = self.window?.rootViewController
            presentedViewCtonroller?.present(alertController, animated: true, completion: nil)
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            //print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            //print(Coordinator.shared.documentsDirectory)
            let coordinator = Coordinator()
            coordinator.importAllFromFirebase()
            // need to import date
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //Coordinator.shared.coreDataManager.saveContext()
    }



}

