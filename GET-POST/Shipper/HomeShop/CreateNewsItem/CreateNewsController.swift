//
//  CreateNewsController.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/3/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol UpdataMapView {
    func setRegion(region: MKCoordinateRegion)
    func showsUserLocation()
    func getCenterLocation() -> CLLocation
}
extension CreateNewsController: UpdataMapView {
    func getCenterLocation() -> CLLocation {
        let latitude = mapViewShop.centerCoordinate.latitude
        let longitude = mapViewShop.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func showsUserLocation() {
        mapViewShop.showsUserLocation = true
    }
    
    func setRegion(region: MKCoordinateRegion) {
        mapViewShop.setRegion(region, animated: true)
    }
}
protocol UpdateUICreateNewsController {
    func updateUIAfterPostItemSucess()
}
extension CreateNewsController: PushPopNavigation {
    func pushVC(view: UIViewController) {}
    func popVC(view: UIViewController) {}
    func present(view: UIViewController) {
        present(view, animated: true)
    }
}
extension CreateNewsController: UpdateUICreateNewsController {
    func updateUIAfterPostItemSucess() {
        viewPostItems.isHidden = false
        viewInfoPostItem.isHidden = false
    }
}
class CreateNewsController: UIViewController {
    
    @IBOutlet weak fileprivate var mapViewShop:             MKMapView!
    
    
    @IBOutlet weak fileprivate var viewInfoPostItem:        UIView!
    
    @IBOutlet weak fileprivate var startPointTextField:     UITextField!
    
    @IBOutlet weak fileprivate var finishPointTextField:    UITextField!
    
    @IBOutlet weak fileprivate var contentTextField:        UITextField!
    
    @IBOutlet weak fileprivate var priceTextField:          UITextField!
    
    @IBOutlet weak fileprivate var prepayTextField:         UITextField!
    
    
    @IBOutlet weak fileprivate var viewPostItems:           UIView!
    
    @IBOutlet weak fileprivate var PostItemButton:          UIButton!
    
    @IBOutlet weak fileprivate var cancelPostItemButton:    UIButton!
    
    
    @IBOutlet weak fileprivate var createItemButton:        UIButton!
    
    @IBOutlet weak fileprivate var switchMapType:           UISegmentedControl!
    
    
    
    
    @IBAction fileprivate func clickButtonPostItem(_ sender: Any) {
        
        presenter?.clickButtonPostItem(startPoint: startPointTextField.text ?? "",
                                       lastPoint: finishPointTextField.text ?? "",
                                       price: priceTextField.text ?? "",
                                       content: contentTextField?.text ?? "",
                                       view: self,
                                       updateUIAfterSuccess: self)
    }
    
    @IBAction fileprivate func clickButtonCancelPostItem(_ sender: Any) {
        viewPostItems.isHidden    = true
        viewInfoPostItem.isHidden = true
        createItemButton.isHidden = false
    }
    
    @IBAction fileprivate func clickButtonCreateItem(_ sender: Any) {
        viewPostItems.isHidden    = false
        viewInfoPostItem.isHidden = false
        createItemButton.isHidden = true
    }
    
    @IBAction fileprivate func clickSwitchMapTypeSegmented(_ sender: Any) {
        
    }
    var presenter: CreateNewsControllerPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewShop.delegate = self
        presenter?.checkLocationServices(mapview: self)
        
        viewPostItems.isHidden    = true
        viewInfoPostItem.isHidden = true
        
    }
}
extension CreateNewsController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        presenter?.checkLocationAuthorization(mapview: self)
        
    }
}
extension CreateNewsController: MKMapViewDelegate {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
