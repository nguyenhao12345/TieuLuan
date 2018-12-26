//
//  PresenterDetailNewController.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/6/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

protocol PresenterDetailNewController {
    func changUIView(view: ChangeUIDetailNewController)
    func getNew(view: ChangeUIDetailNewController)
}

class PresenterDetailNewControllerImp: PresenterDetailNewController {
    private var product: Product
    private var uIDUser: String
    
    init(product: Product, uID: String) {
        self.product = product
        self.uIDUser = uID
    }
    
    func getNew(view: ChangeUIDetailNewController) {
        var arrayChildDetailProduct = ["DetailProduct"]
        
        arrayChildDetailProduct.append(product.getIdDetailProduct())
        FireBaseService.share.getDataHaveManyChild(with: arrayChildDetailProduct) { (value) in
            let detailProduct = DetailProduct(data: value as? [String: Any] ?? [:])
            let ref = FireBaseService.share.getRef().child("DetailProduct").child(self.product.getIdDetailProduct())
            let post = ["UID": self.uIDUser,
                        "status": "Đã nhận"]
            ref.updateChildValues(post)
            view.popToNewsViewController()
        }
    }
    
    func changUIView(view: ChangeUIDetailNewController) {
       
        let idDetailProduct = product.getIdDetailProduct()
        let uID = product.getUID()
        
        ServiceGetDetailNew().getLogin(uID: uID) { (value) in
            view.setUpLabelFullName(fullName: value.getFullName())
            view.setUpLabelPhoneNumber(phoneNumber: value.getPhoneNumber())
        }

        ServiceGetDetailNew().getDetailProduct(idDetailProduct: idDetailProduct) { (value) in
            let idStartPoint = value.getIdStartPoint()
            let idFinishPoint = value.getIdFinishPoint()
            let idItem = value.getIdItem()
            
            DispatchQueue.main.async {
                let textMoneyGet = String(value.getTienShip())
                let advance = String(value.getTienUng())
              
                view.setUplabelMoneyGet(moneyGet: textMoneyGet)
                view.setUpLabelAdvance(advance: advance)
            }
            ServiceGetDetailNew().getStartPoint(idStartPoint: idStartPoint, completion: { (value) in
                DispatchQueue.main.async {
                    view.setUpLabelNameStartPoint(nameStartPoint: value.nameCoordinates)
                }
            })
            ServiceGetDetailNew().getFinishPoint(idFinishPoint: idFinishPoint, completion: { (value) in
                DispatchQueue.main.async {
                    view.setUpLabelNameFinishPoint(nameFinishPoint: value.nameCoordinates)
                }
            })
            
//            ServiceGetDetailNew().getItem(idItem: idItem, completion: { (value) in
//                let mass = value.getMass() + "kg"
//                LoadImageFromService.share.loadPhotoFromService(value.getImageItem(), completion: { (image) in
//                    DispatchQueue.main.async {
//                        view.setUpImageProduct(image: image)
//                    }
//                })
//                DispatchQueue.main.async {
//                    view.setUpLabelMass(mass: mass)
//                    view.setUpLabelNameTitle(nameTitle: value.getTitle())
//                    view.setUpLabelDescription(description: value.getDescription())
//                }
//            })
            
            Service().getItem(idItem: idItem, completion: { (value) in
                let mass = value.getMass() + "kg"
                LoadImageFromService.share.loadPhotoFromService(value.getImageItem(), completion: { (image) in
                    DispatchQueue.main.async {
                        view.setUpImageProduct(image: image)
                    }
                })
                DispatchQueue.main.async {
                    view.setUpLabelMass(mass: mass)
                    view.setUpLabelNameTitle(nameTitle: value.getTitle())
                    view.setUpLabelDescription(description: value.getDescription())
                }
            })
        }
    }
}


