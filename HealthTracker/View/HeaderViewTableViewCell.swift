//
//  HeaderViewTableViewCell.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/28/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class HeaderViewTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
