//
//  NewsControllerCell.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/28/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

class NewsControllerCell: UITableViewCell {
    @IBOutlet weak private var imageAvatar: UIImageView!
    @IBOutlet weak private var labelTime: UILabel!
    @IBOutlet weak private var labelMortgages: UILabel!
    @IBOutlet weak private var labelMoneyGet: UILabel!
    @IBOutlet weak private var labelPointStart: UILabel!
    @IBOutlet weak private var labelPointFinish: UILabel!
    @IBOutlet weak private var labelFullName: UILabel!
    
    func createImage(image: UIImage) {
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
        labelMortgages.text = textMortgages
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let heightAvatar = imageAvatar.frame.height / 2
        imageAvatar.layer.cornerRadius = heightAvatar
        imageAvatar.layer.masksToBounds = true
    }
}
