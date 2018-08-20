//
//  LogoutVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class LogoutVC: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        let coordinator = Coordinator.shared
        coordinator.isAuthenticated = false
        coordinator.showLoginVC(fromVC: self)
        
        
//        dismiss(animated: true) {
//            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
//                self.present(loginVC, animated: true, completion: nil)
//            } else {
//                print("unable to instantiate loginVC")
//            }
////            self.present(self.storyboard?.instantiateInitialViewController(), animated: true, completion: nil)
//        }
//        coordinator.showLoginVC(fromVC: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
