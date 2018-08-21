//
//  URL.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import Foundation

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
