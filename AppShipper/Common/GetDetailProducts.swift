//
//  GetDetailProduct.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/2/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct GetDetailProducts {
    private let detailProducts: [DetailProduct]
    
    init(data: [String: [String: Any]]) {
        var detailProductsClone = [DetailProduct]()
        
        for value in data {
            let detailProduct = DetailProduct(data: value.value)
            
            detailProductsClone.append(detailProduct)
        }
        detailProducts = detailProductsClone
    }
    
    func getDetailProducts() -> [DetailProduct] {
        return detailProducts
    }
}

struct DetailProduct {
    private let idDetailProduct: String
    private let idFinishPoint: String
    private let idStartPoint: String
    private let uIDShiper: String
    private let idItem: String
    private let idReceiver: String
    private let tienShip: Double
    private let tienUng: Double
    private let status: String
    
    init(data: [String: Any]) {
        idDetailProduct = data["IdDetailProduct"] as? String ?? ""
        idFinishPoint = data["IdFinishPoint"] as? String ?? ""
        idStartPoint = data["IdStartPoint"] as? String ?? ""
        idItem = data["idItem"] as? String ?? ""
        tienShip = data["tienShip"] as? Double ?? 0
        tienUng = data["tienUng"] as? Double ?? 0
        uIDShiper = data["UID"] as? String ?? ""
        idReceiver = data["idReceiver"] as? String ?? ""
        status = data["status"] as? String ?? ""
    }
    
    func getIdReceiver() -> String {
        return idReceiver
    }
    
    func getUIDShiper() -> String {
        return uIDShiper
    }
    
    func getIdDetailProduct() -> String {
        return idDetailProduct
    }
    
    func getIdStartPoint() -> String {
        return idStartPoint
    }
    
    func getIdFinishPoint() -> String {
        return idFinishPoint
    }
    
    func getTienUng() -> Double {
        return tienUng
    }
    
    func getTienShip() -> Double {
        return tienShip
    }
    
    func getIdItem() -> String {
        return idItem
    }
    
    func getStatus() -> String {
        return status
    }
}


