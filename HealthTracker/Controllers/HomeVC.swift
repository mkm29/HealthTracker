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
        Coordinator.shared.login { (status) in
            if status {
                if let faceImage = UIImage(named: "Mitch") {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.fadeInNewImage(newImage: faceImage)
                    })
                }
            } else {
                AppDelegate.getAppDelegate().showAlert("Error", "There was an error logging in.")
            }
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
}

