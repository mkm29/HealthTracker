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

class LoginVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(login(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //localAuthentication(tapGestureRecognizer: nil)
//        localAuthentication(tapGestureRecognizer: nil)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let anomImage = UIImage(named: "Anonymous") {
            imageView.image = anomImage
        }
    }
    
    @objc func login(tapGestureRecognizer: UITapGestureRecognizer?) {
        let coordinator = Coordinator()
        setupSliderMenu()
        
//        
//        coordinator.login { (status) in
//            if status {
//                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
//                    self.setupSliderMenu()
//                })
//            } else {
//                AppDelegate.getAppDelegate().showAlert("Error", "There was an error logging in.")
//            }
//        }
    }
    
    func setupSliderMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)

        UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")

        leftViewController.mainViewController = nvc

        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        SlideMenuOptions.contentViewScale = 1
        slideMenuController.delegate = mainViewController
        slideMenuController.coordinator = Coordinator()

        if let window = UIApplication.shared.delegate?.window {
            window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            window?.rootViewController = slideMenuController
            window?.makeKeyAndVisible()
        }
        
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProtected" {
            
        }
    }
}

