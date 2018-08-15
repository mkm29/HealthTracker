//
//  ViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(localAuthentication(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //localAuthentication(tapGestureRecognizer: nil)
//        localAuthentication(tapGestureRecognizer: nil)
//    }
    
    @objc func localAuthentication(tapGestureRecognizer: UITapGestureRecognizer?) -> Void {
        // bypass FaceId for testing
        
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                AppDelegate.getAppDelegate().showAlert("Auth Error", laError.localizedDescription)
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
                    AppDelegate.getAppDelegate().showAlert("Auth Error", "FaceId not supported")
                }
            } else {
                // Fallback on earlier versions
                AppDelegate.getAppDelegate().showAlert("Error", "Unhandled error")
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            // need to add a delay
                            // 1. Fade out Anonymous image
                            if let faceImage = UIImage(named: "Mitch") {
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    self.fadeInNewImage(newImage: faceImage)
                                })
                                
                            }
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
                AppDelegate.getAppDelegate().showAlert("Auth Error", "Can't evaluate policy: \(err)")
            } else {
                errMessage = "Can't evaluate policy"
            }
            AppDelegate.getAppDelegate().showAlert("FaceId Error", errMessage)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowProtected" {
//            let navVC = segue.destination as! UINavigationController
//            if let heathTVC = navVC.viewControllers.first as? HealthTVC {
//                // set the coordinator property
//                heathTVC.coordinator = Coordinator()
//            }
//        }
//    }
    
    func fadeInNewImage(newImage: UIImage?) {
        if newImage == nil {
            return
        }
        
        
        let tmpImageView = UIImageView(image: newImage)
        tmpImageView.contentMode = .scaleAspectFit
        tmpImageView.frame = imageView.bounds
        tmpImageView.alpha = 0.0
        imageView.addSubview(tmpImageView)
        
        UIView.animate(withDuration: 1.75, animations: {
            tmpImageView.alpha = 1.0
            //self.view.backgroundColor = UIColor.white
        }, completion: {
            finished in
            self.imageView.image = newImage
            tmpImageView.removeFromSuperview()
            // request permissions here? or when needed?
            self.performSegue(withIdentifier: "ShowProtected", sender: nil)
        })
    }
}

