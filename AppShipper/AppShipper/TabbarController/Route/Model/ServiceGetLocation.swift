//
//  ServiceGetLocation.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/17/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

class ServiceRoute {
    var arrayLocation = [Location]()
    
    func getDetailProduct(completion: @escaping(GetDetailProducts) -> ()) {
        FireBaseService.share.getData(with: "DetailProduct") {(value) in
        completion(GetDetailProducts(data: value as? [String: [String: Any]] ?? [:]))
        }
    }
    
    func getLocationPointStart(detailProduct: DetailProduct, completion: @escaping(Coordinate) -> ()) {
            var arrayChildCoordinateStart = ["Coordinate"]
            
            arrayChildCoordinateStart.append(detailProduct.getIdStartPoint())
            FireBaseService.share.getDataHaveManyChild(with: arrayChildCoordinateStart) { (value) in
            completion(Coordinate(data: value as? [String: Any] ?? [:]))
        }
    }
    
    func getLocationPointFinish(detailProduct: DetailProduct, completion: @escaping(Coordinate) -> ()) {
        var arrayChildCoordinateFinish = ["Coordinate"]
    
        arrayChildCoordinateFinish.append(detailProduct.getIdFinishPoint())
        FireBaseService.share.getDataHaveManyChild(with: arrayChildCoordinateFinish) { (value) in
            completion(Coordinate(data: value as? [String: Any] ?? [:]))
        }
    }

    func getLocation(uID: String, completion: @escaping([Location]) -> ()) {
        getDetailProduct { (arraydetailProduct) in
            for detailProduct in arraydetailProduct.getDetailProducts() {
                if detailProduct.getUIDShiper() == uID {
                    let location = Location(startPoint: Location.Point(), finishPoint: Location.Point(), uID: detailProduct.getUIDShiper(), idFinishPoint: detailProduct.getIdFinishPoint(), idStartPoint: detailProduct.getIdStartPoint())
                    self.arrayLocation.append(location)
                }
                var arrayChildCoordinateStart = ["Coordinate"]
                
                arrayChildCoordinateStart.append(detailProduct.getIdStartPoint())
                FireBaseService.share.getDataHaveManyChild(with: arrayChildCoordinateStart) { (value) in
                    let coordinate = Coordinate(data: value as? [String: Any] ?? [:])
                    var locationPointStart = Location.Point(longitude: coordinate.getLongitude(), latitude: coordinate.getLatitude(), typeIconLocation: Location.typeIconLocation.shop)
                    var index = 0
                    for location in 0..<self.arrayLocation.count {
                        if self.arrayLocation[location].idStartPoint == coordinate.idCoordinates {
                            index = location
                            locationPointStart.longitude = coordinate.getLongitude()
                            locationPointStart.latitude = coordinate.getLatitude()
                        }
                    }
                    if index < self.arrayLocation.count {
                        self.arrayLocation[index].startPoint = locationPointStart
                    }
                }
                
                var arrayChildCoordinateFinish = ["Coordinate"]
                
                arrayChildCoordinateFinish.append(detailProduct.getIdFinishPoint())
                FireBaseService.share.getDataHaveManyChild(with: arrayChildCoordinateFinish) { (value) in
                    let coordinate = Coordinate(data: value as? [String: Any] ?? [:])
                    var locationPointFinish = Location.Point(longitude: coordinate.getLongitude(), latitude: coordinate.getLatitude(), typeIconLocation: Location.typeIconLocation.receiver)
                    var index = 0
                    for location in 0..<self.arrayLocation.count {
                        if self.arrayLocation[location].idFinishPoint == coordinate.idCoordinates {
                            index = location
                            locationPointFinish.longitude = coordinate.getLongitude()
                            locationPointFinish.latitude = coordinate.getLatitude()
                        }
                    }
                    if index < self.arrayLocation.count {
                        self.arrayLocation[index].finishPoint = locationPointFinish
                    }
                }
                 completion(self.arrayLocation)
            }
        }
    }
}
