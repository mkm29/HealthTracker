//
//  ViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        localAuthentication()
    }
    
    
    @IBAction func faceId(_ sender: Any) {
        localAuthentication()
    }
    func localAuthentication() -> Void {
        
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        print("Starting FaceID")
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                print("laError - \(laError)")
                return
            }
            
            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                if (laContext.biometryType == LABiometryType.faceID) {
                    localizedReason = "Unlock using Face ID"
                    print("FaceId support")
                } else if (laContext.biometryType == LABiometryType.touchID) {
                    localizedReason = "Unlock using Touch ID"
                    print("TouchId support")
                } else {
                    print("No Biometric support")
                }
            } else {
                // Fallback on earlier versions
                print("WTF")
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            print("sucess")
                            self.performSegue(withIdentifier: "ShowProtected", sender: nil)
                        } else {
                            print("failure")
                        }
                    }
                    
                })
            })
        } else {
            print("cant evaluate policy \(error)")
        }
        
        
    }
    
}

