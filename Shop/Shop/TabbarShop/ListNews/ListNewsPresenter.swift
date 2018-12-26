//
//  ListNewsPresenter.swift
//  Shop
//
//  Created by Nguyen Hieu on 12/9/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import Foundation
import UIKit

protocol ListNewsPresenter {
    func cellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func paserDataFromFirebase(tableView: UITableView)
    func count() -> Int
}
class ListNewsPresenterImp: ListNewsPresenter {
    private var uidShop: String = ""
    init(uidShop: String) {
        self.uidShop = uidShop
    }
    func count() -> Int {
//        print(dataProduct.count)
        return dataProductApp.count
    }
    
    func cellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellListNews", for: indexPath) as? CellListNews
            else {
                return UITableViewCell()
        }
        cell.configDataForCell(startPoint: dataProductApp[indexPath.row].startPoint, finishPoint: dataProductApp[indexPath.row].finishPoint, price: dataProductApp[indexPath.row].price, avance: dataProductApp[indexPath.row].avance, nameCustomer: dataProductApp[indexPath.row].nameCustomer, phoneCustomer: dataProductApp[indexPath.row].phoneCustomer, nameShip: dataProductApp[indexPath.row].nameShipper, phoneShip: dataProductApp[indexPath.row].phoneShipper, urlImage: dataProductApp[indexPath.row].image, status: dataProductApp[indexPath.row].status, timeProduct: dataProductApp[indexPath.row].timeProduct)
        return cell
    }
    var dataProductApp: Array<ProductApp> = []
    
    
    func paserDataFromFirebase(tableView: UITableView) {
        FirebaseService.share.ref.child("Product").child(uidShop).observe(.value, with: {(data) in
            self.dataProductApp.removeAll()
            //           print(data.value)
            let dicdata = data.value as? Dictionary<String,Any> ?? [:]
            for (index, i) in dicdata.enumerated() {
                let product = ProductChild(object: i.value)
                let productApp = ProductApp(startPoint: "", finishPoint: "", price: 0, avance: 0, image: "", nameCustomer: "", phoneCustomer: "", nameShipper: "", phoneShipper: "", status: "", timeProduct: "")
                self.dataProductApp.append(productApp)
                
                FirebaseService.share.ref.child("DetailProduct").child(ProductChild(object: i.value).idDetail).observe(.value, with: { (dataDetail) in
                    let dicDetail = dataDetail.value as? Dictionary<String,Any> ?? [:]
                    let dataDetailProduct = DetailProduct(object: dicDetail)
                    print(dataDetailProduct)
                    self.dataProductApp[index].updateDetail(price: Double(dataDetailProduct.tienShip), avance: Double(dataDetailProduct.tienUng), status: dataDetailProduct.status, timeProduct: dataDetailProduct.idDetail)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                    
                    FirebaseService.share.ref.child("Coordinate").child(dataDetailProduct.idStartPoint).observe(.value, with: { (dataStart) in
                        let dicStart = dataStart.value as? Dictionary<String,Any> ?? [:]
                        let dataStart = CoordinateApp(object: dicStart)
                        self.dataProductApp[index].updateStartCoor(startPoint: dataStart.nameCoor)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    })
                    FirebaseService.share.ref.child("Coordinate").child(dataDetailProduct.idFinishPoint).observe(.value, with: { (dataFinish) in
                        let dicFinish = dataFinish.value as? Dictionary<String,Any> ?? [:]
                        let dataFinish = CoordinateApp(object: dicFinish)
                         self.dataProductApp[index].updateFinishCoor(finishPoint: dataFinish.nameCoor)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    })
                    FirebaseService.share.ref.child("Receiver").child(dataDetailProduct.idReceiver).observe(.value, with: { (dataReceive) in
                        let dicReceiver = dataReceive.value as? Dictionary<String,String> ?? [:]
                        let dataReceiver = Receive(object: dicReceiver)
                        self.dataProductApp[index].updateInfoReceive(nameCustomer: dataReceiver.name, phoneCustomer: dataReceiver.phone)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    })
                    FirebaseService.share.ref.child("Item").child(dataDetailProduct.idItem).observe(.value, with: { (dataItem) in
                        let dicItem = dataItem.value as? Dictionary<String,Any> ?? [:]
                        let dataItems = Item(object: dicItem)
                        self.dataProductApp[index].updateItem(image: dataItems.image)
                       print(dataItem)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                            print(dataItem)
                        }
                    })
                    if dataDetailProduct.uid == "" {
                        self.dataProductApp[index].updateInfoShipper(nameShipper: "Chưa có Shipper", phoneShipper: "Chưa có Shipper")
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }
                    else {
                        FirebaseService.share.ref.child("Login").child(dataDetailProduct.uid).observe(.value, with: { (dataShipper) in
                            let dicShip = dataShipper.value as? Dictionary<String,Any> ?? [:]
                            let dataShip = ShipInfo(object: dicShip)
                           self.dataProductApp[index].updateInfoShipper(nameShipper: dataShip.name, phoneShipper: dataShip.phone)
                            DispatchQueue.main.async {
                                tableView.reloadData()
                            }
                        })
                    }
                    
                })
              
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
//            print(self.dataProduct)
            
        })
    }
    
    
    struct ProductApp {
        var startPoint: String
        var finishPoint: String
        var price: Double
        var avance: Double
        var image: String
        var nameCustomer: String
        var phoneCustomer: String
        var nameShipper: String
        var phoneShipper: String
        var status: String
        var timeProduct: String
        init(startPoint: String,finishPoint: String,price: Double,avance: Double, image: String ,nameCustomer: String,
             phoneCustomer: String, nameShipper: String,phoneShipper: String, status: String, timeProduct: String) {
            self.startPoint = startPoint
            self.finishPoint = finishPoint
            self.price = price
            self.avance = avance
            self.image = image
            self.nameCustomer = nameCustomer
            self.phoneCustomer = phoneCustomer
            self.nameShipper = nameShipper
            self.phoneShipper = phoneShipper
            self.status = status
            self.timeProduct = timeProduct
        }
        
        mutating func updateDetail(price: Double, avance: Double, status: String, timeProduct: String) {
            self.price = price
            self.avance = avance
            self.status = status
            self.timeProduct = timeProduct
        }
        mutating func updateStartCoor(startPoint: String) {
            self.startPoint = startPoint
        }
        mutating func updateFinishCoor(finishPoint: String) {
            self.finishPoint = finishPoint
        }
        mutating func updateInfoReceive(nameCustomer: String,phoneCustomer: String) {
            self.nameCustomer = nameCustomer
            self.phoneCustomer = phoneCustomer
        }
        mutating func updateItem(image: String) {
            self.image = image
        }
        mutating func updateInfoShipper(nameShipper: String, phoneShipper: String) {
            self.nameShipper = nameShipper
            self.phoneShipper = phoneShipper
        }
    }

    
    
    struct ShipInfo {
        var name: String
        var phone: String
        init(object:Any) {
            if let dic = object as? Dictionary<String,Any> {
                self.phone = dic["Phonenumber"] as? String ?? ""
                self.name = dic["fullName"] as? String ?? ""
            }
            else {
                self.phone = ""
                self.name = ""
            }
        }
    }
    struct Item {
        var content: String
        var title: String
        var mass: Double
        var image: String
        init(object:Any) {
            if let dic = object as? Dictionary<String,Any> {
                self.content = dic["Description"] as? String ?? ""
                self.title = dic["Title"] as? String ?? ""
                self.mass  = dic["Mass"] as? Double ?? 1
                self.image = dic["ImageItem"] as? String ?? ""
            }
            else {
                self.content = ""
                self.title = ""
                self.mass  = 1
                self.image = ""
            }
        }
    }
    struct Receive {
        var phone: String
        var name: String
        init(object:Any) {
            if let dic = object as? Dictionary<String,String> {
                self.phone = dic["phoneReceiver"] as? String ?? ""
                self.name = dic["nameReceiver"] as? String ?? ""
            }
            else {
                self.phone = ""
                self.name = ""
            }
        }
    }
    
    struct CoordinateApp {
        var idCoor: String
        var latitude: Double
        var longitude: Double
        var nameCoor: String
        init(object:Any) {
            if let dic = object as? Dictionary<String,Any> {
                self.idCoor = dic["IdCoordinates"] as? String ?? ""
                self.latitude = dic["Latitude"] as? Double ?? 1
                self.longitude = dic["Longitude"] as? Double ?? 1
                self.nameCoor = dic["NameCoordinates"] as? String ?? ""
            }
            else {
                self.idCoor = ""
                self.latitude = 1
                self.longitude = 1
                self.nameCoor = ""
            }
        }
    }
    
    struct DetailProduct {
        var idDetail: String
        var idFinishPoint: String
        var idStartPoint: String
        var uid: String
        var idItem: String
        var idReceiver: String
        var tienShip: Double
        var tienUng: Double
        var status: String
        init(object:Any) {
            // có mạng
            if let dic = object as? Dictionary<String,Any> {
                self.idDetail = dic["IdDetailProduct"] as? String ?? ""
                self.idFinishPoint = dic["IdFinishPoint"] as? String ?? ""
                self.idStartPoint = dic["IdStartPoint"] as? String ?? ""
                self.uid = dic["UID"] as? String ?? ""
                self.idItem = dic["idItem"] as? String ?? ""
                self.idReceiver = dic["idReceiver"] as? String ?? ""
                self.tienShip = dic["tienShip"] as? Double ?? 1
                self.tienUng = dic["tienUng"] as? Double ?? 1
                self.status = dic["status"] as? String ?? ""
            }
            else {// đề phòng app ngắt mạng vẫn chạy
                idDetail = ""
                idFinishPoint = ""
                idStartPoint = ""
                uid = ""
                idItem = ""
                idReceiver = ""
                tienShip = 0
                tienUng = 0
                status = "chưa nhận"
            }
        }
    }
    struct ProductChild {
        let idDetail: String
        let idProduct: String
        let uid: String
        let time: String
        init(object:Any) {
            // có mạng
            if let dic = object as? Dictionary<String,String>{
                self.idDetail = dic["IdDetailProduct"] as? String ?? ""
                self.idProduct = dic["IdProduct"] as? String ?? ""
                self.uid = dic["UID"] as? String ?? ""
                self.time = dic["time"] as? String ?? ""
            }
            else {// đề phòng app ngắt mạng vẫn chạy
                idDetail = ""
                idProduct = ""
                uid = ""
                time = ""
            }
        }
        
    }
    var dataTest: [Test] = [Test(start: "oiqhweoiqwneoiqwheoiqwehoiqwe", finish: "quiwgeouqwehowquehqwoed", price: "1283123", avance: "1823712", nameCus: "iqweouqwheoiqe", phoneCus: "ouqwheoqwiheo", nameShip: "qiwehqiwen", phoneShip: "91231231239"),Test(start: "oiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqweoiqhweoiqwneoiqwheoiqwehoiqwe", finish: "quiwgeouqwehowquehqwoed", price: "1283123", avance: "1823712", nameCus: "iqweouqwheoiqe", phoneCus: "ouqwheoqwiheo", nameShip: "qiwehqiwen", phoneShip: "91231231239"),Test(start: "oiqhweoiqwneoiqwheoiqwehoiqwe", finish: "quiwgeouqwehowquehqwoed", price: "1283123", avance: "1823712", nameCus: "iqweouqwheoiqe", phoneCus: "ouqwheoqwiheo", nameShip: "qiwehqiwen", phoneShip: "91231231239")]
}









struct Test {
    var start: String
    var finish: String
    var price: String
    var avance: String
    var nameCustom: String
    var phoneCustome: String
    var nameShip: String
    var phoneShip: String
    init(start: String, finish: String, price: String, avance: String, nameCus: String, phoneCus: String, nameShip: String,
         phoneShip: String) {
        self.avance = avance
        self.price = price
        self.start = start
        self.finish = finish
        self.nameCustom = nameCus
        self.phoneCustome = phoneCus
        self.nameShip = nameShip
        self.phoneShip = phoneShip
    }
}
//            FireBaseService.share.getData(with: "Product") { (value) in
//                products = GetProducts(data: value as?  [String: [String: [String: String]]] ?? [:])
//                groupQueue.leave()
//            }
//            } FirebaseService.share.ref.child("Product").child(uidShop).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                let value = snapshot.value as? NSDictionary
//
//                let idDetailProduct = value?["IdDetailProduct"] as? String ?? ""
//                let idProduct = value?["IdProduct"] as? String ?? ""
//                let uid = value?["UID"] as? String ?? ""
//                let time = value?["time"] as? String ?? ""
//                let product = Product(idDetailProduct: idDetailProduct, idProduct: idProduct, uid: uid, time: time)
//
//                print(product)
//            })
//        }
//    }
//
//    struct Product {
//        var idDetailProduct: DetailProduct
//        var idProduct:       String
//        var uid:             String
//        var time:            String
//        init(data: [String: Any]) {
//            FirebaseService.share.ref.child("Product").child(uid)
//        }
//        struct DetailProduct {
//            var idDetailProduct: String
//            var idFinishPoint:   Coordinate
//            var idStartPoint: Coordinate
//            var idItem: Item
//            var idReceive: Receive
//            var uidShip: AccountShip
//            var price: String
//            var avance: String
//
//
//
//            struct AccountShip {
//                var name: String
//                var phone: String
//                init(data: [String: String]) {
//                    self.name = data["fullName"] ?? ""
//                    self.phone = data["Phonenumber"] ?? ""
//                }
//            }
//            struct Receive {
//                var idReceive: String
//                var nameReceive: String
//                var phoneReceive: String
//                init(data: [String: String]) {
//                    self.idReceive = data["IdReceiver:"] ?? ""
//                    self.nameReceive = data["nameReceiver:"] ?? ""
//                    self.phoneReceive = data["phoneReceiver:"] ?? ""
//                }
//            }
//            struct Item {
//                var content: String
//                var idItem: String
//                var image: String
//                var mass: String
//                var title: String
//                init(data: [String: String]) {
//                    self.content = data["Description:"] as? String ?? ""
//                    self.idItem = data["IdItem:"] as? String ?? ""
//                    self.image = data["ImageItem:"] as? String ?? ""
//                    self.mass = data["Mass:"] ?? ""
//                    self.title = data["Title:"] ?? ""
//                }
//            }
//
//            struct Coordinate {
//                var idCoordinate: String
//                var longitude: Double
//                var latitude: Double
//                var nameCoor: String
//                init(data: [String: Any]) {
//                    self.idCoordinate = data["IdCoordinates:"] as? String ?? ""
//                    self.longitude = data["Longitude:"] as? Double ?? 1
//                    self.latitude = data["Latitude:"] as? Double ?? 1
//                    self.nameCoor = data["NameCoordinates:"] as? String ?? ""
//                    //                FirebaseService.share.ref.child("Coordinate").child()
//                }
//
//
//            }
//        }
//}

