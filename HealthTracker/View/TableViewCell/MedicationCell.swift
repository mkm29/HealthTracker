//
//  MedicationCell.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/14/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class MedicationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
