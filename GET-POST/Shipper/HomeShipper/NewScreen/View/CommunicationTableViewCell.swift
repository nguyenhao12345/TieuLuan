//
//  CommunicationTableView.swift
//  GET-POST
//
//  Created by HaoNguyen on 10/31/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//
import UIKit

class CommunicationTableViewCell: UITableViewCell {
    @IBOutlet weak private var serialLabel: UILabel!
    @IBOutlet weak private var shopNameLabel: UILabel!
    @IBOutlet weak private var locationShopLabel: UILabel!
    @IBOutlet weak private var deliveryLocationLabel: UILabel!
    @IBOutlet weak private var productShopLabel: UILabel!
    @IBOutlet weak private var advanceLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var informationExtraLabel: UILabel!
    
    func config(serialText: String, shopNameText: String, locationShopText: String, deliveyLocationText: String, productShopText: String, advanceText: String, priceText: String, informationExtraText: String) {
        serialLabel.text = serialText
        shopNameLabel.text = shopNameText
        locationShopLabel.text = locationShopText
        deliveryLocationLabel.text = deliveyLocationText
        productShopLabel.text = productShopText
        advanceLabel.text = advanceText
        priceLabel.text = priceText
        informationExtraLabel.text = informationExtraText
    }
}
