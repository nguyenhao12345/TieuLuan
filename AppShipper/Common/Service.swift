//
//  Service.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/10/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

class Service {
    func getDetailProduct(idDetailProduct: String, completion: @escaping(DetailProduct) -> ()) {
        var arrayChildDetailProduct = ["DetailProduct"]
        
        arrayChildDetailProduct.append(idDetailProduct)
        FireBaseService.share.getDataHaveManyChild(with: arrayChildDetailProduct) { (value) in
            completion(DetailProduct(data: value as? [String: Any] ?? [:]))
        }
    }
    
    func getStartPoint(idStartPoint: String, completion: @escaping(Coordinate) -> ()) {
        var arrayChildCoordinate = ["Coordinate"]
        
        arrayChildCoordinate.append(idStartPoint)
        FireBaseService.share.getDataHaveManyChild(with: arrayChildCoordinate) { (value) in
            completion(Coordinate(data: value as? [String: Any] ?? [:]))
        }
    }
    
    func getFinishPoint(idFinishPoint: String, completion: @escaping(Coordinate) -> ()) {
        var arrayChildCoordinate = ["Coordinate"]
        
        arrayChildCoordinate.append(idFinishPoint)
        FireBaseService.share.getDataHaveManyChild(with: arrayChildCoordinate) { (value) in
            completion(Coordinate(data: value as? [String: Any] ?? [:]))
        }
    }
    
    func getItem(idItem: String, completion: @escaping(Item) -> ()) {
        var arrayChildrenItem = ["Item"]
        
        arrayChildrenItem.append(idItem)
        FireBaseService.share.getDataHaveManyChild(with: arrayChildrenItem) { (value) in
            completion(Item(data: value as? [String: String] ?? [:]))
        }
    }
    
    func getLogin(uID: String, completion: @escaping(Login) ->()) {
        var arrayChildrenLogin = ["Login"]
        
        arrayChildrenLogin.append(uID)
        FireBaseService.share.getDataHaveManyChild(with: arrayChildrenLogin) { (value) in
            completion(Login(data: value as? [String: Any] ?? [:]))
        }
    }
    
    func getReceiver(idReceiver: String, completion: @escaping(Receiver) ->()) {
        var arrayChildrenidReceiver = ["Receiver"]
        
        arrayChildrenidReceiver.append(idReceiver)
        FireBaseService.share.getDataHaveManyChild(with: arrayChildrenidReceiver) { (value) in
            completion(Receiver(data: value as? [String: String] ?? [:]))
        }
    }
}

