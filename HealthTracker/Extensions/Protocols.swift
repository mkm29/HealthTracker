//
//  Protocols.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
protocol HealthMenu {
    
    var Open: UIBarButtonItem! { get }
    
    func setupReveal()
}

protocol SetDateTimeVCDelegate {
    func saveDate( date: Date)
}
