//
//  NewsControllerPresenter.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/28/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

protocol NewsControllerPresenter {
    func getData(view: ChangeUIViewController)
    func register(tableView: UITableView)
    func heightForRowAt() -> CGFloat
    func numberOfRowsInSection() -> Int
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAt(didSelectRowAt indexPath: IndexPath, view: ChangeUIViewController)
}

class NewsControllerPresenterImp: NewsControllerPresenter {
    private var uIDUser: String
    private var products = [Product]()
    
    init(uID: String) {
        uIDUser = uID
    }
    
    func getData(view: ChangeUIViewController) {
        ServiceGetNews().getProducts {[weak self] (value) in
            self?.products = value
            view.reload()
        }
        
        
        ServiceGetNews().getProducts {[weak self] (value) in
            self?.products = value
            for index in 0..<value.count {
                Service().getDetailProduct(idDetailProduct: value[index].getIdDetailProduct(), completion: { (value) in
                    guard let count = self?.products.count else { return }
                    if value.getStatus() == "Chưa nhận" && index < count {
                        self?.products.remove(at: index)
                        view.reload()
                    }
                })
            }
        }
    }
    
    func register(tableView: UITableView) {
        tableView.registerNibForCellWithType(type: NewsControllerCell.self)
    }
    
    func heightForRowAt() -> CGFloat {
        return 200
    }
    
    func numberOfRowsInSection() -> Int {
        return products.count
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControllerCell", for: indexPath) as? NewsControllerCell else { return UITableViewCell() }
        let textTime = products[indexPath.row].getTime()
        let idDetailProduct = products[indexPath.row].getIdDetailProduct()
        let uID = products[indexPath.row].getUID()

        cell.createTime(textTime: textTime)
        Service().getLogin(uID: uID) { (value) in
            LoadImageFromService.share.loadPhotoFromService(value.getImage(), completion: { (image) in
                DispatchQueue.main.async {
                    cell.createImage(image: image)
                }
            })
            DispatchQueue.main.async {
                cell.createFullName(textFullName: value.getFullName())
            }
        }

        Service().getDetailProduct(idDetailProduct: idDetailProduct) { (value) in
            let textMoneyGet = String(value.getTienShip())
            let textMortgages = String(value.getTienUng())
            let idStartPoint = value.getIdStartPoint()
            let idFinishPoint = value.getIdFinishPoint()

            DispatchQueue.main.async {
                cell.createMortgages(textMortgages: textMortgages)
                cell.createMoneyGet(textMoneyGet: textMoneyGet)
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
        }
        return cell
    }
    
    func didSelectRowAt(didSelectRowAt indexPath: IndexPath, view: ChangeUIViewController) {
        let detailNewController = instantiate(DetailNewController.self)
        let uID = products[indexPath.row].getUID()
        let idProduct = products[indexPath.row].getIdProduct()
        let idDetailProduct = products[indexPath.row].getIdDetailProduct()
        let time = products[indexPath.row].getTime()
        let product = Product(idDetailProduct: idDetailProduct, idProduct: idProduct, uID: uID, time: time)
        
        detailNewController.inject(presenterNewsController: PresenterDetailNewControllerImp(product: product, uID: uIDUser))
        view.push(to: detailNewController)
    }
}
