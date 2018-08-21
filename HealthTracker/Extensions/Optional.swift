//
//  Extensions.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/14/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
