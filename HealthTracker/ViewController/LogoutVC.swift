//
//  LogoutVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class LogoutVC: UIViewController {
    
    var coordinator: Coordinator?

    override func viewWillAppear(_ animated: Bool) {
        if let coordinator = coordinator {
            coordinator.isAuthenticated = false
        }
        
        dismiss(animated: false) {
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
        }
    }

}
