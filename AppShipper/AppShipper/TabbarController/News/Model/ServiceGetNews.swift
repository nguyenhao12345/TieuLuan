//
//  ServiceGetNews.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/2/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

class ServiceGetNews {
    func getProducts(completion: @escaping([Product]) -> ()) {
        FireBaseService.share.getData(with: "Product") {(value) in
            completion(self.configGetProducts(getProducts: GetProducts(data: value as?  [String: [String: [String: String]]] ?? [:])))
        }
    }
    
    private func configGetProducts(getProducts: GetProducts) -> [Product]{
        var products = [Product]()
        
        for keyUID in getProducts.getKeysUID() {
            for keyIdProduct in keyUID.getIdProduct() {
                products.append(keyIdProduct.getProduct())
            }
        }
        return products
    }
}


