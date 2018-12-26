//
//  StorageProducts.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/11/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct StorageProduct {
    private let idDetailProduct: String
    private let idProduct: String
    private let uID: String
    private let time: String
    private let idFinishPoint: String
    private let idStartPoint: String
    private let idItem: String
    private let uIDShipper: String
    private let idReceiver: String
    private let moneyGet: Double
    private let advance: Double
    
    init(idDetailProduct: String, idProduct: String, uID: String, time: String, idFinishPoint: String, idStartPoint: String, idItem: String, uIDShipper: String, idReceiver: String, moneyGet: Double, advance: Double) {
        self.idDetailProduct = idDetailProduct
        self.uID = uID
        self.time = time
        self.idProduct = idProduct
        self.idFinishPoint = idFinishPoint
        self.idStartPoint = idStartPoint
        self.idItem = idItem
        self.uIDShipper = uIDShipper
        self.idReceiver = idReceiver
        self.moneyGet = moneyGet
        self.advance = advance
    }
    func getIdDetailProduct() -> String {
        return idDetailProduct
    }
    
    func getIdProduct() -> String {
        return idProduct
    }
    
    func getUID() -> String {
        return uID
    }
    
    func getTime() -> String {
        return time
    }
    
    func getIdFinishPoint() -> String {
        return idFinishPoint
    }
    
    func getIdStartPoint() -> String {
        return idStartPoint
    }
    
    func getIdItem() -> String {
        return idItem
    }
    
    func getUIDShipper() -> String {
        return uIDShipper
    }
    
    func getIdReceiver() -> String {
        return idReceiver
    }
    
    func getMoneyGet() -> Double {
        return moneyGet
    }
    
    func getAdvance() -> Double {
        return advance
    }
}

