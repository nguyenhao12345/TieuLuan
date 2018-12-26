//
//  GetReceiver.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/11/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct GetReceivers {
    private let receivers: [Receiver]
    
    init(data: [String: [String: String]]) {
        var receiversClone = [Receiver]()
        
        for value in data {
            let receiver = Receiver(data: value.value)
            
            receiversClone.append(receiver)
        }
        receivers = receiversClone
    }
    
    func getItems() -> [Receiver] {
        return receivers
    }
}

struct Receiver {
    private let idReceiver: String
    private let nameReceiver: String
    private let phoneReceiver: String
    
    init(data: [String: String]) {
        idReceiver = data["IdReceiver"] ?? ""
        nameReceiver = data["nameReceiver"] ?? ""
        phoneReceiver = data["phoneReceiver"] ?? ""
    }
    
    func getIdReceiver() -> String {
        return idReceiver
    }
    
    func getNameReceiver() -> String {
        return nameReceiver
    }
    
    func getPhoneReceiver() -> String {
        return phoneReceiver
    }
}
