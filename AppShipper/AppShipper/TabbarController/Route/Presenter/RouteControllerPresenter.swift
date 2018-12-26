//
//  RouteControllerPresenter.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/17/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation
import MapKit

protocol RouteControllerPresenter {
    func getLocation(view: ChangeUIRouteController)
    func viewForAnnotation(viewFor annotation: MKAnnotation) -> MKAnnotationView?
    func rendererForOverlay(rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    func showRouteForUser(view: ChangeUIRouteController, point: Location.Point)
    func removeRoute(view: ChangeUIRouteController)
    func getStartPoint(startPoint: Location.Point)
}

class RouteControllerPresenterImp: RouteControllerPresenter {
    private var uID: String
    var arrayLocation = [Location]()
    private var startPoint: Location.Point?
    
    init(uID: String) {
        self.uID = uID
    }
    
    func getStartPoint(startPoint: Location.Point) {
        self.startPoint = startPoint
    }
    
    func getLocation(view: ChangeUIRouteController) {
        ServiceRoute().getDetailProduct { (arraydetailProduct) in
            self.arrayLocation = [Location]()
            for detailProduct in arraydetailProduct.getDetailProducts() {
                if detailProduct.getUIDShiper() == self.uID {
                    let location = Location(startPoint: Location.Point(), finishPoint: Location.Point(), uID: detailProduct.getUIDShiper(), idFinishPoint: detailProduct.getIdFinishPoint(), idStartPoint: detailProduct.getIdStartPoint())
                    self.arrayLocation.append(location)
                }
                ServiceRoute().getLocationPointStart(detailProduct: detailProduct, completion: { (coordinate) in
                    var locationPointStart = Location.Point(longitude: coordinate.getLongitude(), latitude: coordinate.getLatitude(), typeIconLocation: Location.typeIconLocation.shop)
                    for location in 0..<self.arrayLocation.count {
                        if self.arrayLocation[location].idStartPoint == coordinate.idCoordinates {
                            locationPointStart.longitude = coordinate.getLongitude()
                            locationPointStart.latitude = coordinate.getLatitude()
                            
                            self.arrayLocation[location].startPoint = locationPointStart
                            DispatchQueue.main.async {
                                view.addMyAnnotation(latitude: self.arrayLocation[location].startPoint.latitude, longitude: self.arrayLocation[location].startPoint.longitude, title: "", subTitle: self.arrayLocation[location].startPoint.subTitle)
                                guard let startPoint = self.startPoint else { return }
                                self.showRouteForUser(view: view, point: startPoint)
                            }
                        }
                    }
                })
                ServiceRoute().getLocationPointFinish(detailProduct: detailProduct, completion: { (coordinate) in
                    
                    var locationPointFinish = Location.Point(longitude: coordinate.getLongitude(), latitude: coordinate.getLatitude(), typeIconLocation: Location.typeIconLocation.receiver)
                    for location in 0..<self.arrayLocation.count {
                        if self.arrayLocation[location].idFinishPoint == coordinate.idCoordinates {
                            locationPointFinish.longitude = coordinate.getLongitude()
                            locationPointFinish.latitude = coordinate.getLatitude()
                            self.arrayLocation[location].finishPoint = locationPointFinish
                            DispatchQueue.main.async {
                                view.addMyAnnotation(latitude: self.arrayLocation[location].finishPoint.latitude, longitude: self.arrayLocation[location].finishPoint.longitude, title: "", subTitle: self.arrayLocation[location].finishPoint.subTitle)
                                guard let startPoint = self.startPoint else { return }
                                self.showRouteForUser(view: view, point: startPoint)
                            }
                        }
                    }
                })
            }
        }
    }
    
    func viewForAnnotation(viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
        guard let subTitle = annotation.subtitle else {
            return nil
        }
        if subTitle == nil {
            return nil
        }
        annotationView.image = UIImage(named: annotation.subtitle as? String ?? "")
        annotationView.frame.size = CGSize(width: 30, height: 30)
        annotationView.canShowCallout = true
         return annotationView
    }
    
    func rendererForOverlay(rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = MKPolylineRenderer(overlay: overlay)
        polyline.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        polyline.lineWidth = 5
        return polyline
    }
    
    func showRouteForUser(view: ChangeUIRouteController, point: Location.Point) {
        let arrayPoint = sortRoute(startPoint: point, arrayStartPointAndFinishPoint: arrayLocation)
        var arrayPointAnnotattion = [MKPointAnnotation]()
        for point in arrayPoint {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate.longitude = point.longitude
            pointAnnotation.coordinate.latitude = point.latitude
            arrayPointAnnotattion.append(pointAnnotation)
        }
        drawMyRoute(view: view, arrayAnnotation: arrayPointAnnotattion)
    }
    
    private func drawMyRoute(view: ChangeUIRouteController, arrayAnnotation: [MKPointAnnotation]) {
        view.removeRoute()
        var index = 0
        while index < arrayAnnotation.count - 1 {
            myRoute(view: view, pointStart: arrayAnnotation[index], pointFinish: arrayAnnotation[index + 1])
            index = index + 1
        }
    }
    
    private func myRoute(view: ChangeUIRouteController, pointStart: MKPointAnnotation, pointFinish: MKPointAnnotation) {
        let sourcePlacemark = MKPlacemark(coordinate: pointStart.coordinate)
        let desPlacemark = MKPlacemark(coordinate: pointFinish.coordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let desMapItem = MKMapItem(placemark: desPlacemark)
        let directionsRequest = MKDirections.Request()
        
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = desMapItem
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (res, error) in
            if error == nil {
                let route = res?.routes[0]
                view.mapViewAddOverlay(route: route ?? MKRoute())
            } else {
                print(error)
            }
        }
    }
    
    func removeRoute(view: ChangeUIRouteController) {
        view.removeRoute()
    }
    
    private func distance(point1: Location.Point, point2: Location.Point) -> Double {
        let xPoint1Point2 = point2.longitude - point1.longitude
        let powXPoint1Point2 = pow(xPoint1Point2, 2)
        let yPoint1Point2 = point2.latitude - point1.latitude
        let powYPoint1Point2 = pow(yPoint1Point2, 2)
        
        return sqrt(powXPoint1Point2 + powYPoint1Point2)
    }
    
    private func sortRoute(startPoint: Location.Point, arrayStartPointAndFinishPoint: [Location]) -> [Location.Point] {
        var arrayStartPointAndFinishPointClone = arrayStartPointAndFinishPoint
        var arrayRoutes = [Location.Point]()
        arrayRoutes.append(startPoint)
        while !arrayStartPointAndFinishPointClone.isEmpty {
            var indexSetNil = 0
            var type = false
            var minDistance: Double = 10000000
            for index in 0..<arrayStartPointAndFinishPointClone.count {
                if arrayStartPointAndFinishPointClone[index].startPoint.longitude == 10000 && arrayStartPointAndFinishPointClone[index].startPoint.latitude == 10000 {
                    if minDistance >= distance(point1: arrayRoutes.last ?? Location.Point(), point2: arrayStartPointAndFinishPointClone[index].finishPoint) {
                        minDistance = distance(point1: arrayRoutes.last ?? Location.Point(), point2: arrayStartPointAndFinishPointClone[index].finishPoint)
                        indexSetNil = index
                        type = false
                    }
                } else {
                    if minDistance >= distance(point1: arrayRoutes.last ?? Location.Point(), point2: arrayStartPointAndFinishPointClone[index].startPoint) {
                        minDistance = distance(point1: arrayRoutes.last ?? Location.Point(), point2: arrayStartPointAndFinishPointClone[index].startPoint)
                        indexSetNil = index
                        type = true
                    }
                }
            }
            if type == true {
                arrayRoutes.append(arrayStartPointAndFinishPointClone[indexSetNil].startPoint)
                arrayStartPointAndFinishPointClone[indexSetNil].setNilForStartPoint()
            } else {
                arrayRoutes.append(arrayStartPointAndFinishPointClone[indexSetNil].finishPoint)
                arrayStartPointAndFinishPointClone[indexSetNil].setNilForFinishPoint()
            }
            if arrayStartPointAndFinishPointClone[indexSetNil].startPoint.longitude == 10000 && arrayStartPointAndFinishPointClone[indexSetNil].startPoint.latitude == 10000 && arrayStartPointAndFinishPointClone[indexSetNil].finishPoint.longitude == 10000 && arrayStartPointAndFinishPointClone[indexSetNil].finishPoint.latitude == 10000 {
                arrayStartPointAndFinishPointClone.remove(at: indexSetNil)
            }
        }
        return arrayRoutes
    }
}

