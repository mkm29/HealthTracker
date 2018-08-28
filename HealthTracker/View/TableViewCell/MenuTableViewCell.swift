//
//  DataTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

struct MenuTableViewCellData {
    
    init(img: UIImage, text: String) {
        self.image = img
        self.text = text
    }
    var image: UIImage
    var text: String
}

class MenuTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataText: UILabel!
    
    override func awakeFromNib() {
        self.dataText?.font = UIFont(name: "Avenir Book", size: 20)
        self.dataText?.textColor = Constants.Colors.blue //UIColor(hex: "9E9E9E")
    }
 
    override class func height() -> CGFloat {
        return 55
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? MenuTableViewCellData {
            self.dataImage.image = data.image
            self.dataText.text = data.text
        }
    }
}
