//
//  Locations.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/16/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct Location {
    var startPoint: Point
    var finishPoint: Point
    var uID: String
    var idFinishPoint: String
    var idStartPoint: String
    
    init(startPoint: Point, finishPoint: Point, uID: String, idFinishPoint: String, idStartPoint: String) {
        self.startPoint = startPoint
        self.finishPoint = finishPoint
        self.uID = uID
        self.idStartPoint = idStartPoint
        self.idFinishPoint = idFinishPoint
    }
    
    mutating func setNilForStartPoint() {
        self.startPoint.longitude = 10000
        self.startPoint.latitude = 10000
    }
    
    mutating func setNilForFinishPoint() {
        self.finishPoint.longitude = 10000
        self.finishPoint.latitude = 10000
    }
    
    enum typeIconLocation {
        case shop
        case receiver
        case user
    }
    
    struct Point {
        var subTitle: String
        var longitude: Double
        var latitude: Double
        
        init(longitude: Double, latitude: Double, typeIconLocation: typeIconLocation) {
            self.longitude = longitude
            self.latitude = latitude
            switch typeIconLocation {
            case .shop:
                subTitle = "shop"
            case .receiver:
                subTitle = "finishPoint"
            case .user:
                 subTitle = ""
            }
        }
        
        init() {
            subTitle = ""
            longitude = 0
            latitude = 0
        }
    }
}
