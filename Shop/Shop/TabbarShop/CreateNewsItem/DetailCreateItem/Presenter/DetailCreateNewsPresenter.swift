//
//  DetailCreateNewsPresenter.swift
//  Shop
//
//  Created by Nguyen Hieu on 12/2/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage


protocol DetailCreateNewsPresenter {
    func test()
    func clickCamera(view: MoveStoryboard)
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any], updataUIImage: UpdateUI)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    
    func clickPostItem(title: String, content: String, mass: Double, price: Double, avance: Double, phoneNumberCustomer: String, nameCustomer: String, image: GetDataFormUIPicker, view: MoveStoryboard, button: UIButton)
}

class DetailCreateNewsPresenterImp: DetailCreateNewsPresenter {


    var groupQueueClickPostItem = DispatchGroup()
    var groupQueueProduct = DispatchGroup()
    
    func clickPostItem(title: String, content: String, mass: Double, price: Double, avance: Double, phoneNumberCustomer: String, nameCustomer: String, image: GetDataFormUIPicker, view: MoveStoryboard,button: UIButton) {
        
        let error = checkFullInput(title: title, content: content, mass: mass, price: price, avance: avance, phoneNumberCustomer: phoneNumberCustomer, nameCustomer: nameCustomer)
        let alert = UIAlertController(title: "Thông báo", message: nil, preferredStyle: .alert)
        
        view.present(view: alert)
        guard error == "" else {
            print(error)
            alert.addAction(UIAlertAction.init(title: error, style: .default,handler:{ (action:UIAlertAction) in
            }))
            return
        }
        
        button.isEnabled = false
        let keyStartPoint = "\(startPointCoordinateCustomer.latitude ?? 123)&\(startPointCoordinateCustomer.longitude ?? 123)"
        let keyStart = keyStartPoint.replacingOccurrences(of: ".", with: ",")
        
        groupQueueClickPostItem.enter()
        pushDataForRootStartPoint(keyStartPoint: keyStart)
        
        let keyFinishPoint = "\(finishPointCoordinateCustomer.latitude ?? 123)*\(finishPointCoordinateCustomer.longitude ?? 123)"
        let keyFinish = keyFinishPoint.replacingOccurrences(of: ".", with: ",")
        
        groupQueueClickPostItem.enter()
        pushDataForRootFinishPoint(keyFinishPoint: keyFinish)
        
        groupQueueClickPostItem.enter()
        pushDataForRootReceiver(keyReceiver: phoneNumberCustomer, name: nameCustomer, phone: phoneNumberCustomer)
        
        groupQueueClickPostItem.enter()
        let keyItem = getTime()
        pushDataForRootItem(keyItem: keyItem, content: content, title: title, mass: mass, image: image)
        
        let idDetailProduct = self.getTime()
        groupQueueClickPostItem.notify(queue: DispatchQueue.main) {
            self.pushDataForRootDetailProduct(idDetailProduct: idDetailProduct, idStart: keyStart, idFinish: keyFinish, idReceiver: phoneNumberCustomer, idItem: keyItem, price: price, avance: avance, completion: {
                self.pushDataForRootProduct(idDetailProduct: idDetailProduct) { (idproduct) in
                    self.isSetSucessRootProduct(idProduct: idproduct, completion: { (ketqua) in
                        switch ketqua {
                           
                        case "Không đăng được, vui lòng kiểm tra kết nối mạng":
                            alert.addAction(UIAlertAction.init(title: ketqua, style: .cancel,handler:{ (action:UIAlertAction) in
                            }))
                        default:
                            alert.addAction(UIAlertAction.init(title: "Thành công", style: .default, handler: { (action:UIAlertAction) in
                               
                                 view.pop()
                                
                            }))
                           
                        }
                    })
                }
            })
        }
    }
    
    // tao ham set data
    func pushDataForRootProduct(idDetailProduct: String, completion: @escaping (String) -> ()) {
        isSetSuccessRootDetailProduct(idDetailProduct: idDetailProduct) { (idDetail) in
            let idProduct = self.getTime()
            let dicProduct = ["IdDetailProduct": idDetailProduct,
                              "IdProduct": idProduct,
                              "UID": self.uid,
                              "time": self.getTime()] as [String : Any]
           ref.child("Product").child(self.uid).child(idProduct).setValue(dicProduct)
            completion(idProduct)
        }
    }
    
    func pushDataForRootDetailProduct(idDetailProduct: String,idStart: String, idFinish: String, idReceiver: String, idItem: String, price: Double, avance: Double, completion: @escaping () -> ()) {
        isSetSuccessRootChildsDetailProduct(idStartPoint: idStart, idFinishPoin: idFinish, idReceiver: idReceiver, idItem: idItem) { (idStartPoint, idFinishPoint, idReceive, idItem) in
            let dicDetailProduct = ["IdDetailProduct": idDetailProduct,
                                    "IdFinishPoint": idFinishPoint,
                                    "IdStartPoint": idStartPoint,
                                    "idItem": idItem,
                                    "idReceiver": idReceive,
                                    "UID": "",
                                    "status": "chưa nhận",
                                    "tienShip": price,
                                    "tienUng": avance] as [String : Any]
            ref.child("DetailProduct").child(idDetailProduct).setValue(dicDetailProduct)
            completion()
        }
    }
    
    func pushDataForRootItem(keyItem: String, content: String, title: String, mass: Double, image: GetDataFormUIPicker) {
        let idItem = keyItem
        // Create a root reference
        let storageRef = Storage.storage().reference()
        // Data in memory
        guard let data = image.getImageFromUIPicker()?.jpegData(compressionQuality: 0.1)
            else { return }
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("imagesItem/\(idItem).jpg")
        // Upload the file to the path
        DispatchQueue.main.async {
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    guard let url = url else { return }
                    let dicItem = ["Description": content,
                                   "Title": title,
                                   "Mass": mass,
                                   "IdItem": idItem,
                                   "ImageItem": url.absoluteString] as [String : Any]
                    DispatchQueue.main.async {
                        ref.child("Item").child(idItem).setValue(dicItem)
                        self.groupQueueClickPostItem.leave()
                    }
                })
            }
        }
    }
    
    func pushDataForRootStartPoint(keyStartPoint: String) {
        let dicStartPoint = ["IdCoordinates": keyStartPoint,
                             "Latitude": Double(startPointCoordinateCustomer.latitude ?? 0),
                             "Longitude": Double(startPointCoordinateCustomer.longitude?.binade ?? 0),
                             "NameCoordinates": startPointCoordinateCustomer.nameCoordinate] as [String : Any]
        ref.child("Coordinate").child(keyStartPoint).setValue(dicStartPoint)
        groupQueueClickPostItem.leave()
    }
    func pushDataForRootFinishPoint(keyFinishPoint: String) {
        let dicFinishPoint = ["IdCoordinates": keyFinishPoint,
                              "Latitude": Double(finishPointCoordinateCustomer.latitude ?? 0),
                              "Longitude": Double(finishPointCoordinateCustomer.longitude ?? 0),
                              "NameCoordinates": finishPointCoordinateCustomer.nameCoordinate] as [String : Any]
        ref.child("Coordinate").child(keyFinishPoint).setValue(dicFinishPoint)
        groupQueueClickPostItem.leave()
    }
    func pushDataForRootReceiver(keyReceiver: String, name: String, phone: String) {
        let idReceiver = keyReceiver
        let dicReceive = ["IdReceiver": idReceiver,
                          "nameReceiver": name,
                          "phoneReceiver": phone] as [String: String]
        ref.child("Receiver").child(idReceiver).setValue(dicReceive)
        groupQueueClickPostItem.leave()
    }
    
    
    //tao ham kiem tra set thanh cong hay chua
    func isSetSucessRootProduct(idProduct: String, completion: @escaping (_ idProduct: String)->()) {
        ref.child("Product").child(uid).child(idProduct).observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                completion(idProduct)
            }
            else {
                completion("Không đăng được, vui lòng kiểm tra kết nối mạng")
                return
            }
        }
    }
    
    func isSetSuccessRootDetailProduct(idDetailProduct: String, completion: @escaping (_ idDetailProduct: String?)->()) {
        ref.child("DetailProduct").child(idDetailProduct).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                completion(idDetailProduct)
            }
            else { return }
        }
    }
    
    
    func isSetSuccessRootChildsDetailProduct(idStartPoint: String, idFinishPoin: String, idReceiver: String,idItem: String ,completion: @escaping (_ idStartPoint: String?,_ idFinishPoin: String?,_ idReceiver: String?,_ idItem: String?)->()) {
        var idstart: String = ""
        var idfinish: String = ""
        var idreciver: String = ""
        var iditem: String = ""
        let groupQueue = DispatchGroup()
        
        groupQueue.enter()
        ref.child("Coordinate").child(idStartPoint).observeSingleEvent(of: .value) { (snapshot) in
             let value = snapshot.value as? NSDictionary
            if value != nil {
                idstart = idStartPoint
                groupQueue.leave()
            }
        }
        
        groupQueue.enter()
        ref.child("Coordinate").child(idFinishPoin).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                idfinish = idFinishPoin
                groupQueue.leave()
            }
        }
        
        groupQueue.enter()
        ref.child("Receiver").child(idReceiver).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                idreciver = idReceiver
                groupQueue.leave()
            }
        }
        
        groupQueue.enter()
        ref.child("Item").child(idItem).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                iditem = idItem
                groupQueue.leave()
            }
        }
//        ref.childByAutoId()
        
        groupQueue.notify(queue: DispatchQueue.main) {
            completion(idstart, idfinish, idreciver, iditem)
        }
    }
    
    func checkFullInput(title: String, content: String, mass: Double?, price: Double?, avance: Double?, phoneNumberCustomer: String,nameCustomer: String) -> String {
        if (title == "" ||  content == "" || mass == nil || price == nil ||
            avance == nil || phoneNumberCustomer == "" || nameCustomer == "") {
            return "Vui lòng điền đầy đủ thông tin"
        }
        else {
            return ""
        }
    }
    func getTime() -> String {
        let formatter = DateFormatter()
        let currentDateTime = Date()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:ssxxxxx"
        formatter.string(from: currentDateTime)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter.string(from: currentDateTime)
    }
    //chọn hình từ camera or lib
    func clickCamera(view: MoveStoryboard) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let actionSheet = UIAlertController(title: "Photos", message: "Choose a Source", preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            view.present(view: imagePickerController)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            view.present(view: imagePickerController)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view.present(view: actionSheet)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any], updataUIImage: UpdateUI) {
        print("aaaaa")
        
        if let image = info[.originalImage] as?  UIImage {
            updataUIImage.updataUIImagePicker(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    private var startPointCoordinateCustomer: CoordinateCustomer = CoordinateCustomer(latitude: nil, longitude: nil, nameCoordinate: "")
    private var finishPointCoordinateCustomer: CoordinateCustomer = CoordinateCustomer(latitude: nil, longitude: nil, nameCoordinate: "")
    private var uid: String = ""

    init(startPointCoordinateCustomer: CoordinateCustomer,finishPointCoordinateCustomer: CoordinateCustomer, uid: String) {
        self.startPointCoordinateCustomer = startPointCoordinateCustomer
        self.finishPointCoordinateCustomer = finishPointCoordinateCustomer
        self.uid = uid
    }
    func test() {
        print(startPointCoordinateCustomer)
        
    }
    
}
struct CoordinateCustomer {
    var latitude:  CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var nameCoordinate: String
    init(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, nameCoordinate: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.nameCoordinate = nameCoordinate
    }
}
extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
