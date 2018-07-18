//
//  UrinateCell.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/13/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class UrinateCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
