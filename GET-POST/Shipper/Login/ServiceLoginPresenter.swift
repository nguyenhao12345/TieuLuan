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
    
    func loginSucess(viewDismis: Dismis, viewPresent: PushPopNavigation) {
        login(userName: numberPhone, passWd: passWd) { [weak self] (result) in
            var presenter: RootTabBarController?
            let sdt = UserDefaults.standard.value(forKey: "numberPhone")
            if let strongSelf = self {
                switch result {
                case .error( _):
                    viewDismis.dismis()
                    return
                case .success(let data):
                    switch data.nameType {
                    case TypeUser.Shop.rawValue:
                        presenter = HomeShopPresenterImp.init(numberPhoneUser: strongSelf.numberPhone)
                        if sdt == nil { UserDefaults.standard.set(strongSelf.numberPhone, forKey: "numberPhone") }
                        else {}
                    case TypeUser.Shipper.rawValue:
                        presenter = HomeShiperPresenterImp()
                        if sdt == nil { UserDefaults.standard.set(strongSelf.numberPhone, forKey: "numberPhone") }
                        else { }
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
    private func useCase(url: API,method: HTTPMethod, dic: Dictionary<String,Any>?, completion: @escaping (LoginResultHaveData) -> ()) {
        news.loadData(urlString: url, method: method, dic: dic) { (object) in
            let errOr = object as? String ?? ""
            if errOr == "sai thong tin" {
                completion(LoginResultHaveData.error(message: "Bạn nhập sai thông tin"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResultHaveData.success(data: user))
            }
        }
    }
    private func login(userName: String, passWd: String?, completion: @escaping (LoginResultHaveData) -> ()) {
        if passWd != nil {
            let dictionary = makeParameter(username: userName, passwd: passWd)
            useCase(url: .login, method: .post, dic: dictionary) { (resultUseCase) in
                switch resultUseCase {
                case .error(let message):
                    completion(.error(message: message))
                case .success(let data):
                    completion(.success(data: data))
                }
            }
        }
        else {
            useCase(url: .getDataLogined, method: .post, dic: ["phonenumber": userName]) { (resultUseCase) in
                switch resultUseCase {
                case .error(let message):
                    completion(.error(message: message))
                case .success(let data):
                    completion(.success(data: data))
                }
            }
        }
        
    }
    
    private func makeParameter(username: String, passwd: String?) -> [String: String] {
        var dic : [String: String] = [:]
        dic["phonenumber"] = username
        dic["passwd"]      = passwd
        return dic
    }
}
