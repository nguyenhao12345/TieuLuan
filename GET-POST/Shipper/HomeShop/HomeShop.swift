//
//  Home.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/21/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


extension HomeShop: TextFieldCustomDelegate {
    func beganTouch(keyText: TextFieldCustom) {
        switch keyText {
        case txtStartPoint:
            print("abc")
        default:
            break
        }
    }
    
    func endedTouch(keyText: TextFieldCustom) {
        if keyText == txtStartPoint {
            print("cab")
        }
    }
}


extension HomeShop: PushPopNavigation {
    func pushVC(view: UIViewController) {
    }
    func present(view: UIViewController) {
        self.present(view, animated: true) {
        }
    }
    func popVC(view: UIViewController) {}
}
extension HomeShop: UpdateUI {
    func enabledButton() {}
    func updateUILableError(lable: String) {
        mesError.text = lable
    }
    func setUIImage() -> UIImage? {
        return UIImage()
    }
    func disableUIButton() {}
    func updataUIImagePicker(image: UIImage) {}
}
protocol UpdateUIHomeShop {
    func updateUIImageAvata(nameImg: String)
    func updateUINameUser(name: String)
    func updateUIPasswd(pass: String)
    func updateUIPhone(phone: String)
    func updataConstrain(numberConstrain: Int)
    func updateUIAfterPostItemSucess()
}
extension HomeShop: UpdateUIHomeShop {
    func updateUIAfterPostItemSucess() {
        viewInfoPost.isHidden = true
        viewBtnPostItem.isHidden = true
        btnclickNewItem.isHidden = false
        
        txtStartPoint.text = ""
        txtLastPoint.text  = ""
        txtPrice.text      = ""
        txtContent.text    = ""
        
    }
    func updataConstrain(numberConstrain: Int) {
    }
    func updateUIPhone(phone: String) {
        view3_Phone.text = phone
    }
    func updateUIPasswd(pass: String) {
        view3_Pass.text = pass
    }
    func updateUINameUser(name: String) {
        lblName.text = name
        view3_Name.text = name
    }
    func updateUIImageAvata(nameImg: String) {
        LoadImageFromService.share.loadPhotoFromService(nameImg, completion: { (imageToCache) in
            self.image.image = imageToCache
            self.view3_Image.image = imageToCache
        })
    }
}
class HomeShop: UIViewController, UISearchBarDelegate {
    // suy nghi doi ten
    @IBOutlet weak var imgCenterMap: UIImageView!
    @IBOutlet weak var view3_Name: UITextField!
    @IBOutlet weak var view3_Phone: UITextField!
    @IBOutlet weak var view3_Pass: UITextField!
    @IBOutlet weak var view3_Image: UIImageView!
    
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    //post items
    @IBOutlet weak var mesError: UILabel!
    @IBOutlet weak var txtStartPoint: UITextField!
    @IBOutlet weak var txtLastPoint: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var btnPostItem: UIButton!
    
    @IBOutlet weak var viewInfoPost: UIView!
    
    @IBOutlet weak var viewBtnPostItem: UIView!
    
 
    @IBAction func changeTypeMap(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapview.mapType = .standard
        case 1:
            mapview.mapType = .satellite
        default:
            break
        }
    }
    
    @IBAction func taptxtStart(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Địa điểm Shipper"
        
        searchController.searchBar.showsCancelButton = true
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func taptxtLast(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Địa điểm Shipper giao hàng"
        searchController.searchBar.showsCancelButton = false
        present(searchController, animated: true, completion: nil)
    }
    // phan anh dung ten cua func, dong tu / cum dong tu
    func tappedReturnButton(_ searchBar: UISearchBar) {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.mapview.annotations
                self.mapview.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapview.addAnnotation(annotation)
                var geocoder = CLGeocoder()
                let location = CLLocation(latitude: latitude ?? 53.9530037, longitude: longitude ?? 1.0867513)
                // [weak self]
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if error != nil {
                        print(error ?? "loi map roi")
                    } else {
                        guard let placemark = placemarks?.first else { return }
                        let streetNumber = placemark.subThoroughfare ?? ""
                        let streetName = placemark.thoroughfare ?? ""
                        let ward = placemark.subLocality ?? ""
                        let city = placemark.locality ?? ""
                        let district = placemark.subAdministrativeArea ?? ""
                        let country = placemark.country ?? ""
                        
                        DispatchQueue.main.async {
                            switch searchBar.placeholder {
                                
                            case "Địa điểm Shipper lấy hàng":
                                self.txtStartPoint.text = "\(streetNumber) , \(streetName) , \(ward) , \(district) , \(city) \(country)"
                            case "Địa điểm Shipper giao hàng":
                                self.txtLastPoint.text = "\(streetNumber) , \(streetName) , \(ward) , \(district) , \(city) \(country)"
                            case .none:
                                break
                            case .some(_):
                                break
                            }
                        }
                    }
                }
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.001, 0.001)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapview.setRegion(region, animated: true)
            }
            
        }
    }
    
    @IBAction func clickCancelCreateNewItem(_ sender: Any) {
        updateUIAfterPostItemSucess()
    }
    
    @IBOutlet weak var btnclickNewItem: UIButton!
    
    @IBAction func clickCreateNewItem(_ sender: Any) {
        viewInfoPost.isHidden = false
        viewBtnPostItem.isHidden = false
        btnclickNewItem.isHidden = true
    }
    @IBAction func clickChangeAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Đổi thông tin tài khoản", message: "Chưa làm chức năng này", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    @IBAction private func clickLogout(_ sender: Any) {
        presenter?.clickLoutout(view: self)
    }
    
    @IBOutlet weak var btnTaiKhoan: UIButton!
    
    @IBAction func clickAccount(_ sender: Any) {
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = false
          navigationItem.title = btnTaiKhoan.titleLabel?.text
    }
    
    @IBOutlet weak var btnBaiDaDang: UIButton!
    @IBAction func clickPosted(_ sender: Any) {
        view1.isHidden = true
        view2.isHidden = false
        view3.isHidden = true
         navigationItem.title = btnBaiDaDang.titleLabel?.text
    }
    @IBAction func clickPost(_ sender: Any) {
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        
        txtStartPoint.text = ""
        txtLastPoint.text  = ""
        txtPrice.text      = ""
        txtContent.text    = ""
       
        navigationItem.title = btnTaoDon.titleLabel?.text
       
    }
    
    @IBOutlet weak var btnTaoDon: UIButton!
    @IBAction func clickPostItem(_ sender: Any) {       //click nút xanh
        presenter?.clickPostItem(startPoint: txtStartPoint.text ?? "" , lastPoint: txtLastPoint.text ?? "", price: txtPrice.text ?? "" , content: txtContent.text ?? "", phonenumber: phone, mesError: self, view: self, constrain: self, updateUIAfterSuccess: self)

    }
    
    var presenter: HomeShopPresenter?
    private var name: String  = ""
    private var hinh: String  = ""
    private var phone: String = ""
    private var pass: String  = ""
    
    func config(name: String, img: String, phone: String, pass: String){
        self.name = name
        self.hinh = img
        self.phone = phone
        self.pass = pass
    }
    //private let news = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomeShopPresenterImp()
        lblName.text = name
        LoadImageFromService.share.loadPhotoFromService(hinh, completion: { (imageToCache) in
            self.image.image = imageToCache
        })
        mapview.mapType = MKMapType.standard
        navigationItem.title = btnTaoDon.titleLabel?.text
        
        view3_Name.text = name
        view3_Pass.text = pass
        view3_Phone.text = phone
        LoadImageFromService.share.loadPhotoFromService(hinh, completion: { (imageToCache) in
            self.view3_Image.image = imageToCache
        })
        
        checkLocationServices()
        mapview.delegate = self
        
        if phone == "" {
            presenter?.getData(lblName: self, image: self, view3_Name: self, view3_Pass: self, view3_Phone: self, view3_Image: self)
        }
        viewInfoPost.isHidden = true
        viewBtnPostItem.isHidden = true
        print(phone)
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true;
        
//        navigationItem.hidesBackButton = true;
    }
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let mkcoor = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1) // độ zoom
            let region = MKCoordinateRegion.init(center: location, span: mkcoor)
            mapview.setRegion(region, animated: true)
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else { }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:  // dc uy quyen khi sd
            startTackingUserLocation()
            break
        case .denied:   //ng dung tu choi
            break
        case .notDetermined:    //k xac dinh
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:   //bi han che
            break
        case .authorizedAlways: //luon luon bat uy quyen
            break
        }
    }
    func startTackingUserLocation() {
        mapview.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapview)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension HomeShop: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
extension HomeShop: MKMapViewDelegate {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let center = getCenterLocation(for: mapView)
//        let geoCoder = CLGeocoder()
//        guard let previousLocation = self.previousLocation else { return }
//        guard center.distance(from: previousLocation) > 1 else { return }
//        self.previousLocation = center
//        geoCoder.reverseGeocodeLocation(center) { (placemarks, error) in
//            if error != nil {
//                print(error ?? "loi map roi")
//            } else {
//                guard let placemark = placemarks?.first else { return }
//                let streetNumber = placemark.subThoroughfare ?? ""
//                let streetName = placemark.thoroughfare ?? ""
//                let ward = placemark.subLocality ?? ""
//                let city = placemark.locality ?? ""
//                let district = placemark.subAdministrativeArea ?? ""
//                let country = placemark.country ?? ""
//
//                DispatchQueue.main.async {
//                    if self.txtStartPoint.isEditing {
//                        self.imgCenterMap.image = UIImage.init(named: "startPoint")
//                        self.txtStartPoint.text = "\(streetNumber) , \(streetName) , \(ward) , \(district) , \(city) \(country)"
//                    }
//                    if self.txtLastPoint.isEditing {
//                        self.imgCenterMap.image = UIImage.init(named: "endPoint")
//                        self.txtLastPoint.text = "\(streetNumber) , \(streetName) , \(ward) , \(district) , \(city) \(country)"
//                    }
//                }
//            }
//        }
//    }
}


