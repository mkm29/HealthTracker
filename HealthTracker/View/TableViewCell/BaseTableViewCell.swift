//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
        // set image?
    }
    
    open class func height() -> CGFloat {
        return 60
    }
    
    open func setData(_ data: Any?) {
        //self.backgroundColor = UIColor(hex: "F7F7F7")
        self.backgroundColor = UIColor.white
        self.textLabel?.font = UIFont(name: "Avenir Book", size: 16)
        self.textLabel?.textColor = UIColor(hex: "9E9E9E")
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
//    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        if highlighted {
//            alpha = 1.0
//        } else {
//            alpha = 0.4
//        }
//    }
//    
//    // ignore the default handling
//    override open func setSelected(_ selected: Bool, animated: Bool) {
//        // make selected menu items highlighted
//        if selected {
//            alpha = 1.0
//        } else {
//            alpha = 0.4
//        }
//    }
  
}
