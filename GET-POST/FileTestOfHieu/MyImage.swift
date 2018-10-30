//
//  MyImage.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/19/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit
struct MyImage {
    var name: String
    var type: String
    var image: UIImage {
        return UIImage(named: name) ?? UIImage()
    }
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}
