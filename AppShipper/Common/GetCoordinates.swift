//
//  GetCoordinates.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/2/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

struct GetCoordinates {
    private let coordinates: [Coordinate]
    
    init(data: [String: [String: Any]]) {
        var coordinatesClone = [Coordinate]()
        
        for value in data {
            let coordinate = Coordinate(data: value.value)
            
            coordinatesClone.append(coordinate)
        }
        coordinates = coordinatesClone
    }
    
    func getCoordinates() -> [Coordinate] {
        return coordinates
    }
}

struct Coordinate {
    let idCoordinates: String
    let latitude: Double
    let longitude: Double
    let nameCoordinates: String
    
    init(data: [String: Any]) {
        idCoordinates = data["IdCoordinates"] as? String ?? ""
        latitude = data["Latitude"] as? Double ?? 0
        longitude = data["Longitude"] as? Double ?? 0
        nameCoordinates = data["NameCoordinates"] as? String ?? ""
    }
    
    func getIdCoordinates() -> String {
        return idCoordinates
    }
    
    func getLatitude() -> Double {
        return latitude
    }
    
    func getLongitude() -> Double {
        return longitude
    }
    
    func getNameCoordinates() -> String {
        return nameCoordinates
    }
}

