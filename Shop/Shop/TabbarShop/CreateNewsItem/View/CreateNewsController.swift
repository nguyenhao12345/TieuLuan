////
////  CreateNewsController.swift
////  GET-POST
////
////  Created by Nguyen Hieu on 11/3/18.
////  Copyright © 2018 datnguyen. All rights reserved.
////
//
import UIKit
import MapKit
import CoreLocation
protocol ViewControllerTabar {
    var nameBar: String { get }
    var index: Int { get }
    var image: UIImage { get }
}
class CreateNewsController: UIViewController, ViewControllerTabar, UISearchBarDelegate {
    var nameBar: String {
        return "Tạo mới"
    }
    var image: UIImage {
        return UIImage.init(named: "tao don") ?? UIImage()
    }
    var index: Int {
        return 0
    }
    
    var coCenter: Bool = true
    
    @IBAction func clickAutoCenterLocation(_ sender: Any) {
        switch coCenter {
        case true:
            coCenter = false
        case false:
            coCenter = true
        }
    }
    
    @IBOutlet weak var timeExpect: UILabel!         //distance
    @IBOutlet weak var startPointLable: UILabel!
    
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var finishPointLable: UILabel!
    @IBOutlet weak var viewDetailPoint: UIView!
    @IBOutlet weak var viewInfoPost: UIView!
    @IBOutlet weak var mapViewShop: MKMapView!
    @IBOutlet weak var finíhPointTextField: UITextField!
    @IBOutlet weak var startPointTextField: UITextField!
    @IBOutlet weak var changeTypeMapSegmentedControl: UISegmentedControl!
    @IBOutlet weak var InfoProductLabel: UILabel!
    
    var presenterCreateNews: CreateNewsControllerPresenter?
    
    
    
    @IBOutlet weak var detailCreateNewsButton: UIButton!
    @IBAction func clickDetailCreateNews(_ sender: Any) {
        presenterCreateNews?.clickDetailCreateNews(view: self, startPoint: startPointTextField.text ?? "" , finishPoint: finíhPointTextField.text ?? "")
    }
    
    @IBAction func clickSwitchPoin(_ sender: Any) {
        viewInfoPost.isHidden = false
        viewDetailPoint.isHidden = true
        finíhPointTextField.text = ""
        startPointTextField.text = ""
        tabBarController?.tabBar.isHidden = false
    }
    @IBAction func clickCreateProduct(_ sender: Any) {
        switch viewInfoPost.isHidden {
        case true:
            viewInfoPost.isHidden = false
        case false:
            viewInfoPost.isHidden = true
        }
    }
    @IBAction func chooseTypeMap(_ sender: UISegmentedControl) {
        presenterCreateNews?.clickSwitchMapTypeSegmented(sender, mapview: self)
    }
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewShop.delegate      = self
        self.viewDetailPoint.isHidden = true
        viewInfoPost.isHidden = true
        presenterCreateNews?.checkLocationServices(mapview: self, locationManagerDelegate: self, locationManager: locationManager)
    }
    
    @IBAction func clickCancelDetailViewPost(_ sender: Any) {
        viewDetailPoint.isHidden = true
        startPointTextField.text = ""
        finíhPointTextField.text = ""
        viewInfoPost.isHidden = true
        tabBarController?.tabBar.isHidden = false
        createPostButton.isEnabled = true
    }
    @IBAction func tapStartPoint(_ sender: Any) {
        guard let searchController = presenterCreateNews?.createSearchBar(placeholder: .LocationShipperGetItem, delegate: self) else {return}
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func tapFinishPoint(_ sender: Any) {
        guard let searchController = presenterCreateNews?.createSearchBar(placeholder: .LocationShipperSendItem, delegate: self) else {return}
        present(searchController, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        if startPointTextField.text != nil && finíhPointTextField.text != nil {
            detailCreateNewsButton.isEnabled = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenterCreateNews?.finishedSearchBar(searchBar, mapview: self, complete: { (address) in
            switch searchBar.placeholder {
            case PlaceholderTextField.LocationShipperGetItem.rawValue:
                self.startPointTextField.text  = address
            case PlaceholderTextField.LocationShipperSendItem.rawValue:
                self.finíhPointTextField.text = address
            case .none:
                break
            case .some(_):
                break
            }
            self.evenAfterInportFullContentPoin()
 
        })
        
    }
    
  
    
    func evenAfterInportFullContentPoin() {
        if self.startPointTextField.text != "" && self.finíhPointTextField.text != "" {
            self.viewDetailPoint.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            startPointLable.text = startPointTextField.text
            finishPointLable.text = finíhPointTextField.text
            viewInfoPost.isHidden = true
            createPostButton.isEnabled = false
            guard let start = startPointLable.text,
                    let finish = finishPointLable.text else {
                        return
                        
            }
            presenterCreateNews?.chiDuong(map: self.mapViewShop, startPointName: start, finishPointName: finish, distance: timeExpect)
            print("aa")
        }
        else {
            self.viewDetailPoint.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.tabBarController?.tabBar.isHidden = false
        finíhPointTextField.text = ""
        startPointTextField.text = ""
        viewInfoPost.isHidden = true
        viewDetailPoint.isHidden = true
        createPostButton.isEnabled = true
        
        let allAnnotations = self.mapViewShop.annotations
        mapViewShop.removeAnnotations(allAnnotations)
        
        let allRouter = self.mapViewShop.overlays
        mapViewShop.removeOverlays(allRouter)
    }
}
protocol MoveStoryboard {
    func present(view: UIViewController)
    func push(view: UIViewController)
    func pop()
    
}
extension CreateNewsController: MoveStoryboard {
    func pop() {
        
    }
    
    func present(view: UIViewController) {
        self.present(view, animated: false, completion: nil)
    }
    func push(view: UIViewController) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(view, animated: true)
    }
}
extension CreateNewsController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if coCenter == true {
            guard let coordinate = locations.last?.coordinate else { return }
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapViewShop.setRegion(region, animated: true)
            coCenter = false
        }
        else {
            return
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        presenterCreateNews?.checkLocationAuthorizationAfterChange(status: status, mapview: self, locationManager: manager)
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
            mapViewShop.mapType       = .standard
        case .satellite:
            mapViewShop.mapType       = .satellite
        case .hybrid:
            mapViewShop.mapType = .hybrid
        case .satelliteFlyover:
            mapViewShop.mapType = .satelliteFlyover
        case .hybridFlyover:
            mapViewShop.mapType = .hybridFlyover
        case .mutedStandard:
            if #available(iOS 11.0, *) { mapViewShop.mapType = .mutedStandard }
            else {}
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

extension CreateNewsController: MKMapViewDelegate {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }

}

enum PlaceholderTextField: String {
    case LocationShipperGetItem = "Địa điểm Shipper nhận hàng"
    case LocationShipperSendItem = "Địa điểm Shipper giao hàng"
}



extension MKMapView {
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            print(route.distance)
            print(route.expectedTravelTime)
            let rect = route.polyline.boundingMapRect
            self.setRegion(MKCoordinateRegion(rect), animated: true)
//            complete.(route)
        }
       
    }
    
    // MARK: - MKMapViewDelegate


}
extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
