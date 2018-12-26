//
//  News.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/4/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct News {
    private let uId: String
    private let idProduct: String
    private let time: String
    private let tienUng: Double
    private let tienShip: Double
    private let fullName: String
    private let nameStartPoint: String
    private let nameFinishPoint: String
    private let idDetailProduct: String
    
    init(uId: String, idProduct: String,time: String, tienUng: Double, tienShip: Double, nameStartPoint: String, nameFinishPoint: String, fullName: String, idDetailProduct: String) {
        self.uId = uId
        self.idProduct = idProduct
        self.time = time
        self.tienUng = tienUng
        self.tienShip = tienShip
        self.fullName = fullName
        self.nameStartPoint = nameStartPoint
        self.nameFinishPoint = nameFinishPoint
        self.idDetailProduct = idDetailProduct
    }
    
    func getIdDetailProduct() -> String {
        return idDetailProduct
    }
    
    func getUID() -> String {
        return uId
    }
    
    func getIdProduct() -> String {
        return idProduct
    }
    
    func getTime() -> String {
        return time
    }
    
    func getTienUng() -> Double {
        return tienUng
    }
    
    func getTienShip() -> Double {
        return tienShip
    }
    
    func getFullName() -> String {
        return fullName
    }
    
    func getNameStartPoint() -> String {
        return nameStartPoint
    }
    
    func getNameFinishPoint() -> String {
        return nameFinishPoint
    }
}
