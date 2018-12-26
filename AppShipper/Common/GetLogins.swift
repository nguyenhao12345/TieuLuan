//
//  GetLogins.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/2/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct GetLogins {
    private let logins: [Login]
    
    init(data: [String: [String: Any]]) {
        var loginsClone = [Login]()
        
        for value in data {
            let login = Login(data: value.value)
            
            loginsClone.append(login)
        }
        logins = loginsClone
    }
    
    func getLogins() -> [Login] {
        return logins
    }
}

struct Login {
    private let cMND: String
    private let idTypeAccount: Int
    private let phoneNumber: String
    private let uID: String
    private let avata: String
    private let fullName: String
    
    init(data: [String: Any]) {
        cMND = data["CMND"] as? String ?? ""
        idTypeAccount = data["IdTypeAccount"] as? Int ?? 0
        phoneNumber = data["Phonenumber"] as? String ?? ""
        uID = data["UID"] as? String ?? ""
        avata = data["avata"] as? String ?? ""
        fullName = data["fullName"] as? String ?? ""
    }
    
    func getImage() -> String {
        return avata
    }
    
    func getUID() -> String {
        return uID
    }
    
    func getFullName() -> String {
        return fullName
    }
    
    func getPhoneNumber() -> String {
        return phoneNumber
    }
    
    func getCMND() -> String {
        return cMND
    }
}
