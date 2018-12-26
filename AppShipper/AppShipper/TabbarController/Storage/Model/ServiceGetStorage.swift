//
//  ServiceGetStorage.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/11/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

class ServiceGetStorage {    
    private func configGetProducts(getProducts: GetProducts) -> [Product]{
        var products = [Product]()
        
        for keyUID in getProducts.getKeysUID() {
            for keyIdProduct in keyUID.getIdProduct() {
                products.append(keyIdProduct.getProduct())
            }
        }
        return products
    }
    
    func getProducts(completion: @escaping([Product]) -> ()) {
        FireBaseService.share.getData(with: "Product") {(value) in
            completion(self.configGetProducts(getProducts: GetProducts(data: value as? [String: [String: [String: String]]] ?? [:])))
        }
    }
    
    func getStorageProducts(uIDUser: String, completion: @escaping([StorageProduct]) -> ()) {
        getProducts { (products) in
            FireBaseService.share.getData(with: "DetailProduct") {(detailProducts) in
                let getDetailProducts = GetDetailProducts(data: detailProducts as? [String: [String: Any]] ?? [:])
                completion(self.mergeProductsAndDetailProducts(uIDUser: uIDUser, products: products, detailProducts: getDetailProducts.getDetailProducts()))
            }
        }
    }
    
    func mergeProductsAndDetailProducts(uIDUser: String, products: [Product], detailProducts: [DetailProduct]) -> [StorageProduct] {
        var storageProducts = [StorageProduct]()
        for product in products {
            let idDetailProduct = product.getIdDetailProduct()
            let detailProduct = detailProducts.first(where: { idDetailProduct == $0.getIdDetailProduct()})
            let idProduct = product.getIdProduct()
            let uID = product.getUID()
            let time = product.getTime()
            let idFinishPoint = detailProduct?.getIdFinishPoint() ?? ""
            let idStartPoint = detailProduct?.getIdStartPoint() ?? ""
            let idItem = detailProduct?.getIdItem() ?? ""
            let uIDShipper = detailProduct?.getUIDShiper() ?? ""
            let idReceiver = detailProduct?.getIdReceiver() ?? ""
            let moneyGet = detailProduct?.getTienShip() ?? 0
            let advance = detailProduct?.getTienUng() ?? 0
            let storageProduct = StorageProduct(idDetailProduct: idDetailProduct, idProduct: idProduct, uID: uID, time: time, idFinishPoint: idFinishPoint, idStartPoint: idStartPoint, idItem: idItem, uIDShipper: uIDShipper, idReceiver: idReceiver, moneyGet: moneyGet, advance: advance)
            
            if uIDUser == storageProduct.getUIDShipper() {
                storageProducts.append(storageProduct)
            }
        }
        return storageProducts
    }
}
