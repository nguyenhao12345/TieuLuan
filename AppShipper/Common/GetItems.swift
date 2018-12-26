//
//  GetItem.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/9/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct GetItems {
    private let items: [Item]
    
    init(data: [String: [String: String]]) {
        var itemsClone = [Item]()
        
        for value in data {
            let item = Item(data: value.value)
            
            itemsClone.append(item)
        }
        items = itemsClone
    }
    
    func getItems() -> [Item] {
        return items
    }
}

struct Item {
    private let idItem: String
    private let description: String
    private let mass: String
    private let title: String
    private let imageItem: String
    
    init(data: [String: String]) {
        idItem = data["IdItem"] ?? ""
        description = data["Description"] ?? ""
        mass = data["Mass"] ?? ""
        title = data["Title"] ?? ""
        imageItem = data["ImageItem"] ?? ""
    }
    
    func getImageItem() -> String {
        return imageItem
    }
    
    func getIdItem() -> String {
        return idItem
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getMass() -> String {
        return mass
    }
    
    func getTitle() -> String {
        return title
    }
}
