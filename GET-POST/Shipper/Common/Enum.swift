//
//  Enum.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/8/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation

enum TypeUser: String {
    case Shop    = "Shop"
    case Shipper = "Shipper"
    case deFault = "default"
    var result: String {
        return self.rawValue
    }
}

enum LoginResultHaveData {
    case error(message: String)
    case success(data: DataUser)
}

enum LoginResult {
    case error(message: String)
    case success(data: String)
}

enum NameViewControllerScreen: String {
    case NewViewController     = "NewViewController"
    case StorageViewController = "StorageViewController"
    case AccountViewController = "AccountViewController"
    case CreateViewController  = "CreateViewController"
}

enum KeyUserDefault: String {
    case typeAccount = "typeAccount"
}

enum TitleItemShop: String {
    case CreateItems = "Tạo đơn"
    case ListItems   = "Danh sách"
    case Account     = "Tài khoản"
}
