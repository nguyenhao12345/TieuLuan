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
    func clickButtonPostItem(startPoint: String, lastPoint: String, price: String, content: String,  view: PushPopNavigation, updateUIAfterSuccess: UpdateUICreateNewsController)
    func checkLocationAuthorization(mapview: UpdataMapView)
    func checkLocationServices(mapview: UpdataMapView)
    func clickSwitchMapTypeSegmented(_ sender: UISegmentedControl, mapview: UpdataMapView)
    func createSearchBar(placeholder: PlaceholderTextField, delegate: UISearchBarDelegate) -> UISearchController
    func createPointAnnotation(latitude: CLLocationDegrees,longitude: CLLocationDegrees, titleAnnotation: String) -> MKPointAnnotation
     func finishedSearchBar(_ searchBar: UISearchBar, mapview: UpdataMapView,complete: @escaping (String) -> ())
}

class CreateNewsControllerImp: CreateNewsControllerPresenter {
    
    func createSearchBar(placeholder: PlaceholderTextField, delegate: UISearchBarDelegate) -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = delegate
        searchController.searchBar.placeholder = placeholder.rawValue
        searchController.searchBar.showsCancelButton = true
        return searchController
    }
    
    
    
    private let postData = Service()
    var numberPhone: String = ""
    var longitude: String = ""
    var latitude: String = ""
    func getDataAfterLogin(phone: String) {
        numberPhone = phone
    }
    func actionUIAlert(titleAlert: String,titleAddAction: String, mesage: String, view: PushPopNavigation) {
        let alert = UIAlertController(title: titleAlert, message: mesage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleAddAction, style: .default, handler: nil))
        view.present(view: alert)
    }
    func clickButtonPostItem(startPoint: String, lastPoint: String, price: String, content: String,  view: PushPopNavigation, updateUIAfterSuccess: UpdateUICreateNewsController) {
        let errMess = checkFullInfo(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content)
        if errMess == nil {
            postItem(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content) {
                [weak self] (result) in
                switch result {
                case .error(let message):
                    if let strongSelf = self {
                        strongSelf.actionUIAlert(titleAlert: "Thất bại", titleAddAction: "Ok", mesage: message, view: view)
                    }
                case .success(let message):
                    if let strongSelf = self {
                        strongSelf.actionUIAlert(titleAlert: "Thành công", titleAddAction: "Ok", mesage: message, view: view)
                    }
                    updateUIAfterSuccess.updateUIAfterPostItemSucess()
                }
            }
        }
        else {
            actionUIAlert(titleAlert: "Thất bại", titleAddAction: "Ok", mesage: errMess ?? "", view: view)
        }
    }
    enum LoginResult {
        case error(message: String)
        case success(message: String)
    }
    func getTime() -> String {
        let formatter = DateFormatter()
        let currentDateTime = Date()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.string(from: currentDateTime)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter.string(from: currentDateTime)
    }
    func convertAddressToCoordinates(address: String, complete: @escaping (CLPlacemark) -> ())  {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            guard let placemark = placemarks?.first else { return }
            complete(placemark)
        }
    }
    func postItem(startPoint: String, lastPoint: String, price: String, content: String, completion: @escaping (LoginResult) -> ()) {
        let dictionary = makeParameter(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content, phonenumber: UserDefaults.standard.object(forKey: "phoneNumber") as? String ?? "", timeOfPost: getTime())
        postData.loadData(urlString: API.postItemOfShop, method: HTTPMethod.post, dic: dictionary) { (object) in
            let errOr = object as? String ?? ""
            if errOr == "k ket noi dc" {
                completion(LoginResult.error(message: "Vui lòng xem lại kết nối mạng"))
            }
            if errOr == "thanh cong"  {
                completion(LoginResult.success(message: "Bài viết của bạn đã được đăng vào news của Shipper"))
            }
        }
    }
    func makeParameter(startPoint: String, lastPoint: String, price: String, content: String ,phonenumber: String, timeOfPost: String) -> [String: String] {
        var dic : [String: String]   =  [:]
        dic["startPoint"] = startPoint
        dic["lastPoint"]   = lastPoint
        dic["price"] = price
        dic["content"] = content
        dic["phonenumber"] = phonenumber
        dic["timePostItem"] = timeOfPost
        dic["longitude"] = longitude
        dic["latitude"] = latitude
        return dic
    }
    
    func checkFullInfo(startPoint: String, lastPoint: String, price: String, content: String) -> String? {
        if startPoint == "" || lastPoint == "" || price == "" || content == "" {
            return "Vui lòng điền đầy đủ thông tin"
        }
        return nil
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
    //map
    func mapDataFromSearchBarToTextField(latitude: CLLocationDegrees,longitude: CLLocationDegrees, searchBar: UISearchBar, complete: @escaping (String) -> ())  {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let ward = placemark.subLocality ?? ""
            let city = placemark.locality ?? ""
            let district = placemark.subAdministrativeArea ?? ""
            let country = placemark.country ?? ""
            
            DispatchQueue.main.async {
                    complete("\(streetNumber) , \(streetName) , \(ward) , \(district) , \(city) \(country)")
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
        let searchRequest = MKLocalSearchRequest()
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
            mapview.mapView(removeAnnotations: annotations)
            
            
            strongSelf.longitude = response?.boundingRegion.center.longitude as? String ?? ""
            strongSelf.latitude = response?.boundingRegion.center.latitude as? String ?? ""
            let pointAnnotation = strongSelf.createPointAnnotation(latitude: response?.boundingRegion.center.latitude ?? 123, longitude: response?.boundingRegion.center.longitude ?? 123, titleAnnotation: searchBar.text ?? "")
            mapview.mapView(addAnnotation: pointAnnotation)
            
            //Zooming in on annotation
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(response?.boundingRegion.center.latitude ?? 123, response?.boundingRegion.center.longitude ?? 123)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapview.setRegion(region: region)
        }
    }
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    func createPointAnnotation(latitude: CLLocationDegrees,longitude: CLLocationDegrees, titleAnnotation: String) -> MKPointAnnotation {
        //Create annotation
        let annotation = MKPointAnnotation()
        annotation.title = titleAnnotation
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        return annotation
    }

    func setupLocationManager() {
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation(mapview: UpdataMapView) {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01) 
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapview.setRegion(region: region)
        }
    }
    func checkLocationServices(mapview: UpdataMapView) {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization(mapview: mapview)
        }
        else { }
    }
    
    func checkLocationAuthorization(mapview: UpdataMapView) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation(mapview: mapview)
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
    func startTackingUserLocation(mapview: UpdataMapView) {
        mapview.showsUserLocation()
        centerViewOnUserLocation(mapview: mapview)
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(mapview: mapview)
    }
    
    func getCenterLocation(mapview: UpdataMapView) -> CLLocation {
        return mapview.getCenterLocation()
    }
}

enum PlaceholderTextField: String {
    case LocationShipperGetItem = "Địa điểm Shipper nhận hàng"
    case LocationShipperSendItem = "Địa điểm Shipper giao hàng"
}
