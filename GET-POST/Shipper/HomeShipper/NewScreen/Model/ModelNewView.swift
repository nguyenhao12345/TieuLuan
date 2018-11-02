//
//  ModelNewView.swift
//  GET-POST
//
//  Created by HaoNguyen on 10/31/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

struct ModelNewView {
    private let shopName: String
    private let locationShop: String
    private let deliveryLocation: String
    private let product: String
    private let advance: Int
    private let price: Int
    private let informationExtra: String
    
    init(shopName: String, locationShop: String, deliveryLocation: String, product: String, advance: Int, price: Int, informationExtra: String) {
        self.shopName = "      " + shopName
        self.locationShop = "           " + locationShop
        self.deliveryLocation = "          " + deliveryLocation
        self.product = "                   " + product
        self.advance = advance
        self.price = price
        self.informationExtra = informationExtra
    }
    
    func getShopName() -> String {
        return shopName
    }
    
    func getLocationShop() -> String {
        return locationShop
    }
    
    func getDeliveryLocation() -> String {
        return deliveryLocation
    }
    
    func getProduct() -> String {
        return product
    }
    
    func getAdvance() -> String {
        return "         " + String(advance) + " đồng"
    }
    
    func getPrice() -> String {
        return "           " + String(price) + " đồng"
    }
    
    func getInformationExtra() -> String {
        return informationExtra
    }
    
    func getTotalHeightModel() -> CGFloat {
        let margin: CGFloat = 80
        
        let heightShopName = shopName.height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let heightLocationShop = locationShop.height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let heightDeliveryLocation = deliveryLocation.height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let heightProduct = product.height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let heightAdvance = getAdvance().height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let heightPrice = getPrice().height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let heightGetInformationExtra = informationExtra.height(constraintedWidth: UIScreen.main.bounds.size.width - margin)
        let totalHeightModel = heightShopName + heightLocationShop + heightDeliveryLocation + heightProduct + heightAdvance + heightPrice + heightGetInformationExtra
        
        return totalHeightModel
    }
}
