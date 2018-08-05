//
//  FirebaseVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/4/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class FirebaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let firebase = FirebaseClient()
        //let meds = firebase.getDocuments(forType: .medication)
//        _ = firebase.getDocuments(forType: .medication) { (documents, error) in
//            guard error == nil, let documents = documents else {
//                AppDelegate.getAppDelegate().showAlert("Error", error!.localizedDescription)
//                return
//            }
//            print("Got \(documents.count) medications")
//        }
        
        // lets add a new Cath document
        if let newCath = firebase.addDocument(.cath, data: ["date" : "08-04-2918", "time" : "11:20 AM", "amount" : 223]) {
            print("Create new cath document: ", newCath.documentID)
        } else {
            print("Unable to create new cath document")
        }
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
