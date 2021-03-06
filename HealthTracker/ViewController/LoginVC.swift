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
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    let laContext = LAContext()
    
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
        if canUseFaceId() {
            login(tapGestureRecognizer: nil)
        }
    }
    
    private func canUseFaceId() -> Bool {
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: nil)) {
            
            if #available(iOS 11.0, *) {
                if (laContext.biometryType == LABiometryType.faceID) {
                    return true
                }
            }
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "password" {
            textField.isSecureTextEntry = true
        }
        textField.text = ""
    }
    
    @objc func login(tapGestureRecognizer: UITapGestureRecognizer?) {
        if canUseFaceId() {
            let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: "Unlock using Face ID", reply: { (isSuccess, error) in
                
                if let laError = error {
                    self.appDelegate.showAlert("Error", laError.localizedDescription)
                } else {
                    if isSuccess {
                        // need to add a delay
                        // 1. Fade out Anonymous image
                        //self.email.text = "mitch.murphy@gmail.com"
                        //self.password.text = "363502"
                        DispatchQueue.main.async {
                            self.setupSliderMenu()
                        }
                    } else {
                        self.appDelegate.showAlert("Error", "Unhandled error")
                    }
                }
            })
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        // just going to hardcode the credentials for now
        guard let email = email.text.nilIfEmpty, let password = password.text.nilIfEmpty else {
            return
        }
        if email == "mitch.murphy@gmail.com" && password == "363502" {
            DispatchQueue.main.async {
                self.setupSliderMenu()
            }
        } else {
            appDelegate.showAlert("Oops", "Make sure you entered your credentials properly and try again.")
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

        //print(slideMenuController.coordinator?.coreDataManager.applicationsDocumentDirectory)
        if let window = UIApplication.shared.delegate?.window {
            window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            window?.rootViewController = slideMenuController
            window?.makeKeyAndVisible()
        }
        
    }
}

