//
//  ServiceLoginPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/11/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
protocol ServiceLoginPresenter {
    func loginSucess(viewDismis: Dismis,viewPresent: PushPopNavigation)
}
class ServiceLoginPresenterImp: ServiceLoginPresenter {
    private let news = Service()
    private var numberPhone: String = ""
    private var passWd: String? = ""
    init(numberPhone: String, passWd: String?) {
        self.numberPhone = numberPhone
        self.passWd      = passWd
    }
    
 
    func loginSucess(viewDismis: Dismis,viewPresent: PushPopNavigation) {
        if passWd == nil {
            loginHavedUserDefault(username: numberPhone) { [weak self](result) in
                var presenter: RootTabBarController?
                if let strongSelf = self {
                    switch result {
                    case .error( _):
                        viewDismis.dismis()
                        return
                    case .success(let data):
                        switch data.nameType {
                        case TypeUser.Shop.rawValue:
                            presenter = HomeShopPresenterImp.init(numberPhoneUser: strongSelf.numberPhone)
                        case TypeUser.Shipper.rawValue:
                            presenter = HomeShiperPresenterImp()
                        default: break
                        }
                    }
                }
                else { return }
                
                let barViewController = TabBarShipperAndShop()
                barViewController.injection(to: presenter)
                viewPresent.present(view: barViewController)
            }
        }
        else {
            login(userName: numberPhone, passWd: passWd) { [weak self](result) in
                var presenter: RootTabBarController?
                if let strongSelf = self {
                    switch result {
                    case .error( _):
                        viewDismis.dismis()
                        return
                    case .success(let data):
                        switch data.nameType {
                        case TypeUser.Shop.rawValue:
                            UserDefaults.standard.set(strongSelf.numberPhone, forKey: "numberPhone")
                            presenter = HomeShopPresenterImp.init(numberPhoneUser: strongSelf.numberPhone)
                        case TypeUser.Shipper.rawValue:
                            UserDefaults.standard.set(strongSelf.numberPhone, forKey: "numberPhone")
                            presenter = HomeShiperPresenterImp()
                        default: break
                        }
                    }
                }
                else { return }
           
                let barViewController = TabBarShipperAndShop()
                barViewController.injection(to: presenter)
                viewPresent.present(view: barViewController)
            }
        }
    }
    func loginHavedUserDefault(username: String, completion: @escaping (LoginResultHaveData) -> ()) {
        news.loadData(urlString: API.getDataLogined, method: .post, dic: ["phonenumber": username],
        completion: { (object) in
            let errOr = object as? String ?? ""
            if errOr == "sai thong tin" {
                completion(LoginResultHaveData.error(message: "Bạn nhập sai thông tin"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResultHaveData.success(data: user))
            }
        })
    }
    
    func login(userName: String, passWd: String?, completion: @escaping (LoginResultHaveData) -> ()) {
        let dictionary = makeParameter(username: userName, passwd: passWd)
        news.loadData(urlString: API.login, method: HTTPMethod.post, dic: dictionary, completion: { (object) in
            let errOr = object as? String ?? ""
            if errOr == "sai thong tin" {
                completion(LoginResultHaveData.error(message: "Bạn nhập sai thông tin"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResultHaveData.success(data: user))
            }
        })
    }
    
    func makeParameter(username: String, passwd: String?) -> [String: String] {
        var dic : [String: String] = [:]
        dic["phonenumber"] = username
        dic["passwd"]      = passwd
        return dic
    }
}
