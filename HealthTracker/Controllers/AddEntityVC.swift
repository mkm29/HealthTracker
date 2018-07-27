//
//  AddEntityVC.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/25/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class AddEntityVC: UIViewController {
    
    let coreDataManager = CoreDataManager.shared
    
    var entityType: Constants.EntityType { fatalError("entity must be overridden") }

    func addEntity(fromDict dict: [String:Any]) {
        _ = coreDataManager.createNewObject(ofType: entityType, objectDictionary: dict)
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
