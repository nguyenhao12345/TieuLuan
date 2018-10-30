//
//  API.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/20/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit

enum API:String {
    case listSP = "GETSP.php"
    case postImage = "postText.php"
    case upimage = "learn.php"
    case signUp = "SignUser.php"
    case login = "Login_User.php"
    case postItemOfShop = "AddItemOfShop.php"
    case getDataLogined = "getDataLogined.php"
    var fullLink: String{
        return "http://appnhacdat.pe.hu/" + self.rawValue
    }
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    var method: String{
        return self.rawValue
    }
}

