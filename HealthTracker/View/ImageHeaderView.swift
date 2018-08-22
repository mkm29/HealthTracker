//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(hex: "E0E0E0")
        profileImage.layoutIfNeeded()
        profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.setRandomDownloadImage(80, height: 80)
        backgroundImage.setRandomDownloadImage(Int(self.bounds.size.width), height: 160)
    }
}
