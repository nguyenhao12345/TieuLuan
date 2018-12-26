//
//  CreateNewsControllerPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/4/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol CreateNewsControllerPresenter {
    func clickSwitchMapTypeSegmented(_ sender: UISegmentedControl, mapview: UpdataMapView)
    func checkLocationAuthorization(mapview: UpdataMapView,locationManager: CLLocationManager)
    func checkLocationServices(mapview: UpdataMapView,locationManagerDelegate: CLLocationManagerDelegate,locationManager: CLLocationManager)
   func clickDetailCreateNews(view: MoveStoryboard, startPoint: String, finishPoint: String)
    func createSearchBar(placeholder: PlaceholderTextField, delegate: UISearchBarDelegate) -> UISearchController
     func checkLocationAuthorizationAfterChange(status: CLAuthorizationStatus, mapview: UpdataMapView,locationManager: CLLocationManager)
    func finishedSearchBar(_ searchBar: UISearchBar, mapview: UpdataMapView,complete: @escaping (String) -> ())
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation],map: UpdataMapView)
    func chiDuong(map: MKMapView,startPointName: String, finishPointName: String, distance: UILabel)
}
class CreateNewsControllerPresenterImp: CreateNewsControllerPresenter {
   
    func chiDuong(map: MKMapView,startPointName: String, finishPointName: String, distance: UILabel) {
        convertAddressToCLLocation(address: startPointName) { (startCoor) in
            self.convertAddressToCLLocation(address: finishPointName, complete: { (finishCoor) in
         
                let localSource = CLLocation(latitude: startCoor.latitude, longitude: startCoor.longitude)
                
                let localDes = CLLocation(latitude: finishCoor.latitude, longitude: finishCoor.longitude)
                
                let location2DSource = CLLocationCoordinate2D(latitude: localSource.coordinate.latitude, longitude: localSource.coordinate.longitude)
                let location2DDes = CLLocationCoordinate2D(latitude: localDes.coordinate.latitude, longitude: localDes.coordinate.longitude)
                
                let req = MKDirections.Request()
                
                let source = MKPlacemark(coordinate: location2DSource, addressDictionary: nil)
                let destination = MKPlacemark(coordinate: location2DDes, addressDictionary: nil)
                
                
                req.source = MKMapItem(placemark: source)
                req.destination = MKMapItem(placemark: destination)
                req.transportType = .automobile
                
                let direc = MKDirections(request: req)
                
                direc.calculate { (response, error) in
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    let route = response.routes[0]
                    map.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
//                    print(route.distance)
//                    print(route.expectedTravelTime)
                    let rect = route.polyline.boundingMapRect
                    map.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                    
                    distance.text = String(route.distance.binade / 1000)
                    
                    //String(Double(route.distance.description ?? "123") ?? 123456  / 1000)
                }
            })
        }
       
    }
    
    func convertAddressToCLLocation(address: String, complete: @escaping (CLLocationCoordinate2D) -> ())  {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            guard let placemark = placemarks?.first else {
                return }
            let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
            complete(coordinates)
        }
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation], map: UpdataMapView){
//        let center = CLLocationCoordinate2D(latitude: previousLocation?.coordinate.latitude ?? 123, longitude: previousLocation?.coordinate.longitude ?? 123)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        map.setRegion(region: region)
//    }
    
 
    var uid: String = ""
    init(uid: String) {
        self.uid = uid
    }
    
    
    func convertAddressToCoordinates(address: String, complete: @escaping (CoordinateCustomer) -> ())  {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
            complete(CoordinateCustomer(latitude: coordinates.latitude, longitude: coordinates.longitude, nameCoordinate: address))
        }
    }
    
    
    
    func createSearchBar(placeholder: PlaceholderTextField, delegate: UISearchBarDelegate) -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = delegate
        searchController.searchBar.placeholder = placeholder.rawValue
        searchController.searchBar.showsCancelButton = true
        return searchController
    }
    func mapDataFromSearchBarToTextField(latitude: CLLocationDegrees,longitude: CLLocationDegrees, searchBar: UISearchBar, complete: @escaping (String) -> ())  {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let ward = placemark.subLocality ?? ""
//            let city = placemark.locality ?? ""
//            let district = placemark.subAdministrativeArea ?? ""
            
            DispatchQueue.main.async {
                complete("\(streetNumber),\(streetName),\(ward)")
//                    ",\(district),\(city)")
            }
        }
    }
    func finishedSearchBar(_ searchBar: UISearchBar, mapview: UpdataMapView, complete: @escaping (String) -> ())  {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Hide search bar
        searchBar.resignFirstResponder()
        //        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { [weak self] ( response, error ) in
            UIApplication.shared.endIgnoringInteractionEvents()
            
            guard let strongSelf = self, response != nil else { return }
            
            //mapLocation to TextField
            
            strongSelf.mapDataFromSearchBarToTextField(latitude:  response?.boundingRegion.center.latitude ?? 123, longitude: response?.boundingRegion.center.longitude ?? 123, searchBar: searchBar, complete: { (address) in
                complete(address)
            })
            
            
            //Remove annotations
            
            let annotations = mapview.createAnnotation()
//            mapview.mapView(removeAnnotations: annotations)
            

            let pointAnnotation = strongSelf.createPointAnnotation(latitude: response?.boundingRegion.center.latitude ?? 123, longitude: response?.boundingRegion.center.longitude ?? 123, titleAnnotation: searchBar.text ?? "")
            mapview.mapView(addAnnotation: pointAnnotation)
            
            //Zooming in on annotation
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(response?.boundingRegion.center.latitude ?? 123, response?.boundingRegion.center.longitude ?? 123)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapview.setRegion(region: region)
            searchBar.isHidden = true
        }
    }
//    let locationManager = CLLocationManager()
    
//    var previousLocation: CLLocation?
    func createPointAnnotation(latitude: CLLocationDegrees,longitude: CLLocationDegrees, titleAnnotation: String) -> MKPointAnnotation {
        //Create annotation
        let annotation = MKPointAnnotation()
        annotation.title = titleAnnotation
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        return annotation
    }
    
    
    func clickDetailCreateNews(view: MoveStoryboard, startPoint: String, finishPoint: String) {
        let viewDetailCreateNews = instantiate(DetailCreateNews.self)
        
        convertAddressToCoordinates(address: startPoint) { (startCoor) in

                self.convertAddressToCoordinates(address: finishPoint) { (finishCoor) in
                    viewDetailCreateNews.inject(presenter: DetailCreateNewsPresenterImp(startPointCoordinateCustomer: startCoor, finishPointCoordinateCustomer: finishCoor, uid: self.uid))
                    view.push(view: viewDetailCreateNews)
                }
        }
        
        
    }
    
    
    func clickSwitchMapTypeSegmented(_ sender: UISegmentedControl, mapview: UpdataMapView) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapview.getMapType(nameType: .standard)
        case 1:
            mapview.getMapType(nameType: .satellite)
        default:
            break
        }
    }
    
    func setupLocationManager(locationManagerDelegate: CLLocationManagerDelegate,locationManager: CLLocationManager) {
        locationManager.delegate = locationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func addPointInMapView(mapview: UpdataMapView,locationManager: CLLocationManager) {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapview.setRegion(region: region)
        }
    }
    func checkLocationServices(mapview: UpdataMapView,locationManagerDelegate: CLLocationManagerDelegate,locationManager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager(locationManagerDelegate: locationManagerDelegate, locationManager: locationManager)
            checkLocationAuthorization(mapview: mapview, locationManager: locationManager)
        }
        else {
//            checkLocationAuthorization(mapview: mapview)
            print("location service not enable")
        }
    }
    func checkLocationAuthorizationAfterChange(status: CLAuthorizationStatus, mapview: UpdataMapView,locationManager: CLLocationManager) {
        switch status {
        case .authorizedWhenInUse:
            startTackingUserLocation(mapview: mapview, locationManager: locationManager)
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    func checkLocationAuthorization(mapview: UpdataMapView,locationManager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation(mapview: mapview, locationManager: locationManager)
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    func startTackingUserLocation(mapview: UpdataMapView,locationManager: CLLocationManager) {
        mapview.showsUserLocation()
        addPointInMapView(mapview: mapview, locationManager: locationManager)
        locationManager.startUpdatingLocation()
//        previousLocation = getCenterLocation(mapview: mapview)
    }
    
    func getCenterLocation(mapview: UpdataMapView) -> CLLocation {
        return mapview.getCenterLocation()
    }
}
