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
}
class CreateNewsControllerImp: CreateNewsControllerPresenter {
    private let postData = Service()
    var numberPhone: String = ""
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
    
    func postItem(startPoint: String, lastPoint: String, price: String, content: String, completion: @escaping (LoginResult) -> ()) {
        let dictionary = makeParameter(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content, phonenumber: UserDefaults.standard.object(forKey: "phoneNumber") as? String ?? "")
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
    func makeParameter(startPoint: String, lastPoint: String, price: String, content: String ,phonenumber: String) -> [String: String] {
        var dic : [String: String]   =  [:]
        dic["startPoint"] = startPoint
        dic["lastPoint"]   = lastPoint
        dic["price"] = price
        dic["content"] = content
        dic["phonenumber"] = phonenumber
        return dic
    }
    
    func checkFullInfo(startPoint: String, lastPoint: String, price: String, content: String) -> String? {
        if startPoint == "" || lastPoint == "" || price == "" || content == "" {
            return "Vui lòng điền đầy đủ thông tin"
        }
        return nil
    }
    
    
    
    
    //map
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    func setupLocationManager() {
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation(mapview: UpdataMapView) {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1) 
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

