//
//  MenuCell.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
