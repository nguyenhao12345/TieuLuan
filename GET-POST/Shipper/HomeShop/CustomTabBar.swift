//
//  CustomTabBar.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/4/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//


import UIKit

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}
