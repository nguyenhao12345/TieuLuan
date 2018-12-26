//
//  StorageControllerCell.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/30/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

class StorageControllerCell: UITableViewCell {
    @IBOutlet weak private var labelFullName: UILabel!
    @IBOutlet weak private var labelPointFinish: UILabel!
    @IBOutlet weak private var labelPointStart: UILabel!
    @IBOutlet weak private var labelMoneyGet: UILabel!
    @IBOutlet weak private var labelMortGages: UILabel!
    @IBOutlet weak private var imageAvatar: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        let heightAvatar = imageAvatar.frame.height / 2
        imageAvatar.layer.cornerRadius = heightAvatar
        imageAvatar.layer.masksToBounds = true
    }
    
    func createImageAvatar(image: UIImage) {
        imageAvatar.image = image
    }
    
    func createFullName(textFullName: String) {
        labelFullName.text = textFullName
    }
    
    func createPointFinish(textPointFinish: String) {
        labelPointFinish.text = textPointFinish
    }
    
    func createPointStart(textPointStart: String) {
        labelPointStart.text = textPointStart
    }
    
    func createMoneyGet(textMoneyGet: String) {
        labelMoneyGet.text = textMoneyGet
    }
    
    func createTime(textTime: String) {
        labelTime.text = textTime
    }
    
    func createMortgages(textMortgages: String) {
        labelMortGages.text = textMortgages
    }
}
