//
//  Login1Presenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/23/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit
protocol Login1Presenter {
    func clickLogin(userName: String, passWd: String, view: PushPopNavigation, updateLable: UpdateUI,buttonLogin: UpdateUI)
    func clickSign(view: PushPopNavigation)
}
class Login1PresenterImp: Login1Presenter {
//    var dataUIHomeShop: DataUser? = nil
    func clickSign(view: PushPopNavigation) {
        let viewSigin = instantiate(Sign1.self, storyboard: "Sign1")
        view.pushVC(view: viewSigin)
    }
    private let news = Service()
    func clickLogin(userName: String, passWd: String, view: PushPopNavigation, updateLable: UpdateUI,buttonLogin: UpdateUI) {
        let errMess = checkFullInfo(userName: userName, passWd: passWd)
        guard errMess == nil else {
            updateLable.updateUILableError(lable: errMess ?? "")
            return
        }
        login(userName: userName, passWd: passWd, buttonLogin: buttonLogin) { (result) in
            switch result {
            case .error(let message):
                updateLable.updateUILableError(lable: message)
            case .success(let data):
                 UserDefaults.standard.set(userName, forKey: "phoneNumber")
                if data.nameType == "Shop" {
                    UserDefaults.standard.set(data.nameType, forKey: "typeAccount")
                    self.navigationPushHomeShop(data: data, view: view)
                }
                if data.nameType == "Shipper" {
                     UserDefaults.standard.set(data.nameType, forKey: "typeAccount")
                    self.navigationPushHomeShipper(data: data, view: view)
                }
            }
        }
        
    }
    
    enum LoginResult {
        case error(message: String)
        case success(data: DataUser)
    }
    
    func login(userName: String, passWd: String,buttonLogin: UpdateUI, completion: @escaping (LoginResult) -> ()) {
        let dictionary = makeParameter(username: userName, passwd: passWd)
        buttonLogin.updataUIButton()
        news.loadData(urlString: API.login, method: HTTPMethod.post, dic: dictionary, completion: {
            (object) in
            let errOr = object as? String ?? ""
            if errOr == "sai thong tin" {
                buttonLogin.enabledButton()
                completion(LoginResult.error(message: "Bạn nhập sai thông tin"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResult.success(data: user))
            }
        })
    }
    
    func checkSpecialCharacter(userName: String) -> String? {
        if CheckSpecialCharacter.share.checkCharacterIsNumber(string: userName) {
            return "Tên đăng nhập phải là số điện thoại"
        }
        return nil
    }
    
    func checkFullInfo(userName: String, passWd: String) -> String? {
        if userName == "" || passWd == "" {
            return "Vui lòng điền đầy đủ thông tin"
        }
        return checkSpecialCharacter(userName: userName)
    }
    
    func makeParameter(username: String, passwd: String) -> [String: String] {
        var dic : [String: String] = ["phonenumber": "", "passwd": ""]
        dic["phonenumber"] = username
        dic["passwd"]   = passwd
        return dic
    }
    func navigationPushHomeShop(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(TabBarHomeShop.self, storyboard: "TabBarHomeShop")
        viewControllerMain.getDataAfterLoginOrSign(numberPhone: data.phonenumber)
//        viewControllerMain.config(name: data.nameUser, img: data.image, phone: data.phonenumber, pass: data.pass)
//        view.present(view: viewControllerMain)
        view.pushVC(view: viewControllerMain)
    }
    func navigationPushHomeShipper(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(HomeShipper.self, storyboard: "HomeShipper")
        view.pushVC(view: viewControllerMain)
    }
}
extension Login1PresenterImp: HomeShopPresenterDelegate {
    func printData() {
        print("a")
        //        print(dataUIHomeShop?.nameUser)
        //        print(dataUIHomeShop?.image)
        //        print(dataUIHomeShop?.nameType)
        //        print(dataUIHomeShop?.pass)
        //        print(dataUIHomeShop?.phonenumber)
    }
}
