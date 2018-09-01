//
//  PhysicianTableViewCell.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/29/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class PhysicianTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var hospitalLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
