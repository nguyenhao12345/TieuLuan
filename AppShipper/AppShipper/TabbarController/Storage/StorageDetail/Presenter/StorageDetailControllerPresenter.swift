//
//  StorageDetailControllerPresenter.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/11/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

protocol StorageDetailControllerPresenter {
    func changUIView(view: ChangeUIStorageDetailController)
    func deleteProduct(view: ChangeUIStorageDetailController)
}

class StorageDetailControllerPresenterImp: StorageDetailControllerPresenter {
    private var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    func deleteProduct(view: ChangeUIStorageDetailController) {
        var arrayChildDetailProduct = ["DetailProduct"]
        
        arrayChildDetailProduct.append(product.getIdDetailProduct())
        FireBaseService.share.getDataHaveManyChild(with: arrayChildDetailProduct) { (value) in
            let detailProduct = DetailProduct(data: value as? [String: Any] ?? [:])
            let ref = FireBaseService.share.getRef().child("DetailProduct").child(self.product.getIdDetailProduct())
            let post = ["UID": "",
                        "status": "Chưa nhận"]
            ref.updateChildValues(post)
            view.popToStorageController()
        }
    }
    
    func changUIView(view: ChangeUIStorageDetailController) {
        let idDetailProduct = product.getIdDetailProduct()
        let uID = product.getUID()
        
        Service().getLogin(uID: uID) { (value) in
            view.setUpLabelFullNameShop(fullName: value.getFullName())
            view.setUpLabelPhoneNumberShop(phoneNumber: value.getPhoneNumber())
            view.setUpLabelCardIdShop(cardId: value.getCMND())
        }
        
        Service().getDetailProduct(idDetailProduct: idDetailProduct) { (value) in
            let idStartPoint = value.getIdStartPoint()
            let idFinishPoint = value.getIdFinishPoint()
            let idItem = value.getIdItem()
            let idReceiver = value.getIdReceiver()
            
            DispatchQueue.main.async {
                let textMoneyGet = String(value.getTienShip())
                let advance = String(value.getTienUng())
                
                view.setUplabelMoneyGet(moneyGet: textMoneyGet)
                view.setUpLabelAdvance(advance: advance)
            }
            Service().getReceiver(idReceiver: idReceiver) { (value) in
                DispatchQueue.main.async {
                    view.setUpLabelFullNameReceiver(fullName: value.getNameReceiver())
                    view.setUpLabelPhoneNumberReceiver(phoneNumber: value.getPhoneReceiver())
                }
            }
            Service().getStartPoint(idStartPoint: idStartPoint, completion: { (value) in
                DispatchQueue.main.async {
                    view.setUpLabelNameStartPoint(nameStartPoint: value.nameCoordinates)
                }
            })
            Service().getFinishPoint(idFinishPoint: idFinishPoint, completion: { (value) in
                DispatchQueue.main.async {
                    view.setUpLabelNameFinishPoint(nameFinishPoint: value.nameCoordinates)
                }
            })
            
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
