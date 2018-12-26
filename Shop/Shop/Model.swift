////
////  Model.swift
////  Shop
////
////  Created by Nguyen Hieu on 11/22/18.
////  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
////
//
//import Foundation
//
//struct AppShip {
//    var coordinates: [CoordinateApp]
//    var logins: [Login]
//    var detailProducts: [DetailProduct]
//    var items: [Item]
//    var products: [Product]
//    var receivers: [Receiver]
//    var typeAccounts: [TypeAccount]
//    struct CoordinateApp {
//    }
//    struct Login {
//    }
//    struct DetailProduct {
//    }
//    struct Item {
//    }
//    struct Product {
//
//    }
//    struct Receiver {
//        var phoneReceiver: String
//        var nameReceivert: String
//        init(data: [String: String]) {
//            self.phoneReceiver = data["phoneReceiver"] ?? ""
//            self.nameReceivert = data["nameReceivert"] ?? ""
//        }
//    }
//    struct TypeAccount {
//        var idTypeAccount: Int
//        var nameTypeAccount: String
//        init(data: [String: Any]) {
//            self.idTypeAccount = data["IdTypeAccount"] as? Int ?? 0
//            self.nameTypeAccount = data["NameTypeAccount"] as? String ?? ""
//        }
//    }
//}
