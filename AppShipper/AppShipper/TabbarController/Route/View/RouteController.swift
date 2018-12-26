//
//  RouteController.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/12/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit
import MapKit

protocol ChangeUIRouteController {
    func addMyAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subTitle: String)
    func mapViewAddOverlay(route: MKRoute)
    func removeRoute()
}

extension RouteController: ChangeUIRouteController {
    func addMyAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subTitle: String) {
        let pointAnnotation =  MKPointAnnotation()
        
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pointAnnotation.title = title
        pointAnnotation.subtitle = subTitle
        mapRoute.addAnnotation(pointAnnotation)
    }
    
    func mapViewAddOverlay(route: MKRoute) {
        mapRoute.addOverlay((route.polyline))
    }
    
    func removeRoute() {
        mapRoute.removeOverlays(mapRoute.overlays)
    }
}

class RouteController: UIViewController, ViewControllerTabar {
    var titleBar: String {
        return "Route"
    }
    
    var imageBar: String {
        return "route2"
    }
    var coCenter: Bool = true

    @IBAction func clickCenterAuto(_ sender: Any) {
        switch coCenter {
        case true:
            coCenter = false
        default:
            coCenter = true
        }
    }
    private var pointAnnotation = MKPointAnnotation()
    private var mylocation = MKPointAnnotation()
    @IBOutlet weak private var mapRoute: MKMapView!
    let locations = [Location]()
    private var presenter: RouteControllerPresenter?
    private var locationManager = CLLocationManager()

    
    func inject(routeControllerPresenter: RouteControllerPresenter) {
        presenter = routeControllerPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getLocation(view: self)
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func mapAddArrayPointAnnotattion(pointAnnotattions: [PointAnnotattion]) {
        for pointAnnotattion in pointAnnotattions {
            mapRoute.addAnnotation(pointAnnotattion.pointAnnotattionStart)
            mapRoute.addAnnotation(pointAnnotattion.pointAnnotattionFinish)
        }
    }
    
    func createArrayPointAnnotattion(locations: [Location]) -> [PointAnnotattion] {
        var pointAnnotattionsTyple = [PointAnnotattion]()
        for location in locations {
            let pointAnnotationStart = MKPointAnnotation()
            pointAnnotationStart.coordinate = CLLocationCoordinate2D(latitude: location.startPoint.longitude, longitude: location.startPoint.latitude)
            pointAnnotationStart.subtitle = location.startPoint.subTitle
            let pointAnnotationFinish = MKPointAnnotation()
            pointAnnotationFinish.coordinate = CLLocationCoordinate2D(latitude: location.finishPoint.longitude, longitude: location.finishPoint.latitude)
            pointAnnotationFinish.subtitle = location.finishPoint.subTitle
           pointAnnotattionsTyple.append(PointAnnotattion(pointAnnotattionStart: pointAnnotationStart, pointAnnotattionFinish: pointAnnotationFinish))
        }
        return pointAnnotattionsTyple
    }
}

extension MKMapView {
    func location(latitude: CLLocationDegrees, longitude: CLLocationDegrees, latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        self.region = MKCoordinateRegion(center: locationCoordinate2D, span: coordinateSpan)
        addPointAnnotation(latitude: latitude, longitude: longitude, title: "", subTitle: "")
    }
    
    func addPointAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subTitle: String) {
        let pointAnnotation =  MKPointAnnotation()
        
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pointAnnotation.title = title
        pointAnnotation.subtitle = subTitle
        self.addAnnotation(pointAnnotation)
    }
}

extension RouteController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return presenter?.viewForAnnotation(viewFor: annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return presenter?.rendererForOverlay(rendererFor: overlay) ?? MKOverlayRenderer()
    }
}

extension RouteController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if coCenter == true {
            let userLocation = locations.last
            guard let longitudeUserLocation = locations.last?.coordinate.longitude, let latitudeUserLocation = locations.last?.coordinate.latitude else { return }
            let pointUserLocation = Location.Point(longitude: longitudeUserLocation, latitude: latitudeUserLocation, typeIconLocation: .user)
            presenter?.getStartPoint(startPoint: pointUserLocation)
            presenter?.showRouteForUser(view: self, point: pointUserLocation)
            let viewRegion = MKCoordinateRegion(center: userLocation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapRoute.setRegion(viewRegion, animated: true)
            mapRoute.showsUserLocation = true
            coCenter = false
        }
        else {
            return
        }
    }
}

struct PointAnnotattion {
    var pointAnnotattionStart: MKPointAnnotation
    var pointAnnotattionFinish: MKPointAnnotation
    
    init(pointAnnotattionStart: MKPointAnnotation, pointAnnotattionFinish: MKPointAnnotation) {
        self.pointAnnotattionStart = pointAnnotattionStart
        self.pointAnnotattionFinish = pointAnnotattionFinish
    }
}

