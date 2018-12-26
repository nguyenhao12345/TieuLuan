//
//  StorageControllerPresenter.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/30/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

protocol StorageControllerPresenter {
    func register(tableView: UITableView)
    func heightForRowAt() -> CGFloat
    func numberOfRowsInSection() -> Int
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func getData(view: ChangeUIViewController)
    func didSelectRowAt(didSelectRowAt indexPath: IndexPath, view: ChangeUIViewController)
}

class StorageControllerPresenterImp: StorageControllerPresenter {
    private var uID: String
    private var storageProducts = [StorageProduct]()
    
    init(uID: String) {
        self.uID = uID
    }
    
    func getData(view: ChangeUIViewController) {
        ServiceGetStorage().getStorageProducts(uIDUser: uID) {[weak self] (value) in
            self?.storageProducts = value
            view.reload()
        }
    }
    
    func register(tableView: UITableView) {
        tableView.registerNibForCellWithType(type: StorageControllerCell.self)
    }
    
    func heightForRowAt() -> CGFloat {
        return 200
    }
    
    func numberOfRowsInSection() -> Int {
        return storageProducts.count
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageControllerCell", for: indexPath) as? StorageControllerCell else { return UITableViewCell() }
        let textTime = storageProducts[indexPath.row].getTime()
        let uID = storageProducts[indexPath.row].getUID()
        let textMoneyGet = String(storageProducts[indexPath.row].getMoneyGet())
        let textMortgages = String(storageProducts[indexPath.row].getAdvance())
        let idStartPoint = storageProducts[indexPath.row].getIdStartPoint()
        let idFinishPoint = storageProducts[indexPath.row].getIdFinishPoint()
        
        cell.createTime(textTime: textTime)
        cell.createMortgages(textMortgages: textMortgages)
        cell.createMoneyGet(textMoneyGet: textMoneyGet)
        Service().getLogin(uID: uID) { (value) in
            LoadImageFromService.share.loadPhotoFromService(value.getImage(), completion: { (image) in
                DispatchQueue.main.async {
                    cell.createImageAvatar(image: image)
                }
            })
            DispatchQueue.main.async {
                cell.createFullName(textFullName: value.getFullName())
            }
        }
        if idStartPoint != "" {
            Service().getStartPoint(idStartPoint: idStartPoint, completion: { (value) in
                DispatchQueue.main.async {
                    cell.createPointStart(textPointStart: value.getNameCoordinates())
                }
            })
        }
        if idFinishPoint != "" {
            Service().getFinishPoint(idFinishPoint: idFinishPoint, completion: { (value) in
                DispatchQueue.main.async {
                    cell.createPointFinish(textPointFinish: value.getNameCoordinates())
                }
            })
        }
        return cell
    }
    
    func didSelectRowAt(didSelectRowAt indexPath: IndexPath, view: ChangeUIViewController) {
        let storageDetailController = instantiate(StorageDetailController.self)
        let uID = storageProducts[indexPath.row].getUID()
        let idProduct = storageProducts[indexPath.row].getIdProduct()
        let idDetailProduct = storageProducts[indexPath.row].getIdDetailProduct()
        let time = storageProducts[indexPath.row].getTime()
        let product = Product(idDetailProduct: idDetailProduct, idProduct: idProduct, uID: uID, time: time)
        
        storageDetailController.inject(storageDetailControllerPresenter: StorageDetailControllerPresenterImp.init(product: product))
        view.push(to: storageDetailController)
    }
}
