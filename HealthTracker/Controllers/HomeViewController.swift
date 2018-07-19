//
//  ViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/11/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ubeView: UIView!
    
    var hamburgerMenuIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(Coordinator.shared.coreDataManager.applicationDocumentsDirectory())
    }

    @IBAction func toggleMenu(_ sender: Any) {
        if !hamburgerMenuIsVisible {
            leadingConstraint.constant = 150
            trailingConstraint.constant = -150
            hamburgerMenuIsVisible = true
        } else {
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
            hamburgerMenuIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            //print("The animation is complete!")
        }
    }
    
}

