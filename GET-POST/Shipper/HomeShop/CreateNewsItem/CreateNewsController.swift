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

class CreateNewsController: UIViewController, UISearchBarDelegate {
    
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
    
    @IBAction func tapstartPointTextField(_ sender: Any) {
        guard let searchController = presenter?.createSearchBar(placeholder: .LocationShipperGetItem, delegate: self) else {return}
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func tapfinishPointTextField(_ sender: Any) {
        guard let searchController =  presenter?.createSearchBar(placeholder: .LocationShipperSendItem, delegate: self) else {return}
        present(searchController, animated: true, completion: nil)
    }
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
    
    @IBAction fileprivate func clickSwitchMapTypeSegmented(_ sender: UISegmentedControl) {
        presenter?.clickSwitchMapTypeSegmented(sender, mapview: self)
    }
    
    var presenter: CreateNewsControllerPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewShop.delegate = self
        presenter?.checkLocationServices(mapview: self)
        
        viewPostItems.isHidden    = true
        viewInfoPostItem.isHidden = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.finishedSearchBar(searchBar, mapview: self, complete: { (address) in
            switch searchBar.placeholder {
            case PlaceholderTextField.LocationShipperGetItem.rawValue:
                self.startPointTextField.text = address
            case PlaceholderTextField.LocationShipperSendItem.rawValue:
                self.finishPointTextField.text = address
            case .none:
                break
            case .some(_):
                break
            }
        })
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
protocol UpdataMapView {
    func setRegion(region: MKCoordinateRegion)
    func showsUserLocation()
    func getCenterLocation() -> CLLocation
    func getMapType(nameType: MKMapType)
    func mapView(removeAnnotations:  [MKAnnotation])
    func mapView(addAnnotation: MKAnnotation)
    func createAnnotation() -> [MKAnnotation]
}
extension CreateNewsController: UpdataMapView {
    func createAnnotation() -> [MKAnnotation] {
        return mapViewShop.annotations
    }
    
    func mapView(removeAnnotations: [MKAnnotation]) {
        mapViewShop.removeAnnotations(removeAnnotations)
    }
    
    func mapView(addAnnotation: MKAnnotation) {
        mapViewShop.addAnnotation(addAnnotation)
    }
    func getMapType(nameType: MKMapType) {
        switch nameType {
        case .standard:
            mapViewShop.mapType = .standard
        case .satellite:
            mapViewShop.mapType = .satellite
        case .hybrid:
            mapViewShop.mapType = .hybrid
        case .satelliteFlyover:
            mapViewShop.mapType = .satelliteFlyover
        case .hybridFlyover:
            mapViewShop.mapType = .hybridFlyover
        case .mutedStandard:
            if #available(iOS 11.0, *) {
                mapViewShop.mapType = .mutedStandard
            } else {
            }
        }
    }
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

