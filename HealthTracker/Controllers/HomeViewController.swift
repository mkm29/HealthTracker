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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(localAuthentication(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        localAuthentication(tapGestureRecognizer: nil)
    }
    
    @objc func localAuthentication(tapGestureRecognizer: UITapGestureRecognizer?) -> Void {
        // bypass FaceId for testing
        self.performSegue(withIdentifier: "ShowProtected", sender: nil)
        
        
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                showAlert("Auth Error", laError.localizedDescription)
                return
            }
            
            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                if (laContext.biometryType == LABiometryType.faceID) {
                    localizedReason = "Unlock using Face ID"
                    //print("FaceId support")
                } else if (laContext.biometryType == LABiometryType.touchID) {
                    localizedReason = "Unlock using Touch ID"
                    //print("TouchId support")
                } else {
                    print("No Biometric support")
                    showAlert("Auth Error", "FaceId not supported")
                }
            } else {
                // Fallback on earlier versions
                showAlert("Error", "Unhandled error")
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            self.performSegue(withIdentifier: "ShowProtected", sender: nil)
                        } else {
                            print("failure")
                        }
                    }
                    
                })
            })
        } else {
            var errMessage = ""
            if error != nil {
                errMessage = error!.localizedDescription
            }
            if let err = error?.localizedDescription {
                showAlert("Auth Error", "Can't evaluate policy: \(err)")
            } else {
                errMessage = "Can't evaluate policy"
            }
            showAlert("FaceId Error", errMessage)
        }
    }
}

