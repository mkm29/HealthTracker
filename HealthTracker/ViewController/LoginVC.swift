//
//  ViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication
import SlideMenuControllerSwift

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var faceID: UIImageView!
    
    
    override func viewDidLoad() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(login(tapGestureRecognizer:)))
        faceID.isUserInteractionEnabled = true
        faceID.addGestureRecognizer(tapGestureRecognizer)
        email.addBorder(type: .Bottom, color: UIColor.darkGray, withWidth: 1)
        password.addBorder(type: .Bottom, color: UIColor.darkGray, withWidth: 1)
        password.delegate = self
        email.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //login(tapGestureRecognizer: nil)
    }
    
//    @objc func login(tapGestureRecognizer: UITapGestureRecognizer?) {
//        let coordinator = Coordinator()
//        setupSliderMenu()
//
//
//        coordinator.login { (status) in
//            if status {
//                self.setupSliderMenu()
////                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
////                    self.email.text = "mitch.murphy@gmail.com"
////                    self.password.text = "123456789"
////                    self.setupSliderMenu()
////                })
//            } else {
//                AppDelegate.getAppDelegate().showAlert("Error", "There was an error logging in.")
//            }
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "password" {
            textField.isSecureTextEntry = true
        }
        textField.text = ""
    }
    
    @objc func login(tapGestureRecognizer: UITapGestureRecognizer?) {
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
                            DispatchQueue.main.async {
                                self.setupSliderMenu()
                            }
                        } else {
                            AppDelegate.getAppDelegate().showAlert("Error", "Unhandled error")
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
    
    func setupSliderMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        SlideMenuOptions.contentViewScale = 1
        slideMenuController.delegate = mainViewController
        slideMenuController.coordinator = Coordinator()
        slideMenuController.coordinator?.isAuthenticated = true

        if let window = UIApplication.shared.delegate?.window {
            window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            window?.rootViewController = slideMenuController
            window?.makeKeyAndVisible()
        }
        
    }
    
//    func fadeInNewImage(newImage: UIImage?) {
//        if newImage == nil {
//            return
//        }
//
//
//        let tmpImageView = UIImageView(image: newImage)
//        tmpImageView.contentMode = .scaleAspectFit
//        tmpImageView.frame = imageView.bounds
//        tmpImageView.alpha = 0.0
//        imageView.addSubview(tmpImageView)
//
//        UIView.animate(withDuration: 1.75, animations: {
//            tmpImageView.alpha = 1.0
//            //self.view.backgroundColor = UIColor.white
//        }, completion: {
//            finished in
//            self.imageView.image = newImage
//            tmpImageView.removeFromSuperview()
//            // request permissions here? or when needed?
//            self.performSegue(withIdentifier: "ShowProtected", sender: nil)
//        })
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowProtected" {
//
//        }
//    }
}

