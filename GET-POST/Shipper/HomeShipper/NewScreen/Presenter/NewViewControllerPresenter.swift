//
//  NewViewControllerPresenter.swift
//  GET-POST
//
//  Created by HaoNguyen on 10/31/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

protocol NewViewControllerPresenter {
    func register(nibName: String, forCellWithReuseIdentifier: String, tableView: UITableView)
    func numberOfRowsInSection() -> Int
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func heightForRowAt() -> CGFloat
}

class NewViewControllerPresenterImp: NewViewControllerPresenter {
    private let NewShop = ModelNewView.init(shopName: "Nguyen Hao", locationShop: "So 1 Vo Van Ngan Thu Du", deliveryLocation: "367 Chau Thanh Soc Trang", product: "Canh Hoa", advance: 15000, price: 3000000, informationExtra: "ban phai giao dung gio")
    func register(nibName: String, forCellWithReuseIdentifier: String, tableView: UITableView) {
        let communicationNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(communicationNib, forCellReuseIdentifier: "communicationTableViewCell")
    }
    
    func numberOfRowsInSection() -> Int {
        return 10
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let communicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "communicationTableViewCell", for: indexPath) as? CommunicationTableViewCell else { return UITableViewCell()}
        let serial = String(indexPath.row) + ":"
        let ShopName = NewShop.getShopName()
        let locationShop = NewShop.getLocationShop()
        let deliveryLocation = NewShop.getDeliveryLocation()
        let product = NewShop.getProduct()
        let advance = NewShop.getAdvance()
        let price = NewShop.getPrice()
        let informationExtra = NewShop.getInformationExtra()
        communicationTableViewCell.config(serialText: serial, shopNameText: ShopName, locationShopText: locationShop, deliveyLocationText: deliveryLocation, productShopText: product, advanceText: advance, priceText: price, informationExtraText: informationExtra)
        print(NewShop.getTotalHeightModel())
        return communicationTableViewCell
    }
    
    func heightForRowAt() -> CGFloat {
        let margin: CGFloat = 115
        let totalHeightModelNewView = NewShop.getTotalHeightModel()
        let totalHeight = margin + totalHeightModelNewView
        return totalHeight
    }
}
