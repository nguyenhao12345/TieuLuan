//
//  GetNews.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/2/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct GetProducts {
    private let keys: [KeyUID]
    
    init(data: [String: [String: [String: String]]]) {
        var keysClone = [KeyUID]()
        
        for value in data {
            let key = KeyUID(data: value.value, key: value.key)
            
            keysClone.append(key)
        }
        keys = keysClone
    }
    
    func getKeysUID() -> [KeyUID]  {
        return keys
    }
    
    struct KeyUID {
        private let keyUID: String
        private let keysProduct: [keyIdProduct]
        
        init(data: [String: [String: String]], key: String) {
            var keysProductClone = [keyIdProduct]()
            
            for value in data {
                let keyProduct = keyIdProduct(data: value.value, key: value.key)
                
                keysProductClone.append(keyProduct)
              
            }
            keysProduct = keysProductClone
            keyUID = key
        }
        
        func getIdProduct() -> [keyIdProduct] {
            return keysProduct
        }
        
        struct keyIdProduct {
            private let idProduct: String
            private let product: Product
            
            init(data: [String: String], key: String) {
                idProduct = key
                product = Product(data: data)
                
            }
            
            func getProduct() -> Product {
                return product
            }
        }
    }
}

struct Product {
    private let idDetailProduct: String
    private let idProduct: String
    private let uID: String
    private let time: String
    
    init(data: [String: String]) {
        idDetailProduct = data["IdDetailProduct"] ?? ""
        idProduct = data["IdProduct"] ?? ""
        uID = data["UID"] ?? ""
        time = data["time"] ?? ""
    }
    
    init(idDetailProduct: String, idProduct: String, uID: String, time: String) {
        self.idDetailProduct = idDetailProduct
        self.uID = uID
        self.time = time
        self.idProduct = idProduct
    }
    
    func getTime() -> String {
        return time
    }
    
    func getIdDetailProduct() -> String {
        return idDetailProduct
    }
    
    func getUID() -> String {
        return uID
    }
    
    func getIdProduct() -> String {
        return idProduct
    }
}
