//
//  Protocols.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

protocol HealthTVC {
    
    var Open: UIBarButtonItem! { get }
    
    var coordinator: Coordinator! { get set }
    
    func setupReveal()
}
