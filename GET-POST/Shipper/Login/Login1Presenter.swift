//
//  Login1Presenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/23/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

protocol Login1Presenter {
    func clickLogin(userName: String, passWd: String, view: PushPopNavigation, updateLable: UpdateUI, buttonLogin: UpdateUI)
    func clickSign(view: PushPopNavigation)
}

class Login1PresenterImp: Login1Presenter {
    private let news = Service()
    
    func clickSign(view: PushPopNavigation) {
        let viewSigin = instantiate(Sign1.self, storyboard: "Sign1")
        view.pushVC(view: viewSigin)
    }
    
    func clickLogin(userName: String, passWd: String, view: PushPopNavigation, updateLable: UpdateUI, buttonLogin: UpdateUI) {
        let errMess = checkFullInfo(userName: userName, passWd: passWd)
        guard errMess == nil else {
            updateLable.updateUILableError(lable: errMess ?? "")
            return
        }
        login(userName: userName, passWd: passWd, buttonLogin: buttonLogin) { [weak self] (result) in
            switch result {
            case .error(let message):
                updateLable.updateUILableError(lable: message)
            case .success(let data):
                if let strongSelf = self {
                    switch data.nameType {
                    case TypeUser.Shop.rawValue:
                        UserDefaults.standard.set(true, forKey: KeyUserDefault.typeAccount.rawValue)
                        strongSelf.navigationPushHomeShop(data: data, view: view)
                    case TypeUser.Shipper.rawValue:
                        UserDefaults.standard.set(false, forKey: KeyUserDefault.typeAccount.rawValue)
                        strongSelf.navigationPushHomeShipper(data: data, view: view)
                    default: break
                    }
                }
                else { return }
            }
        }
    }
    
    func login(userName: String, passWd: String, buttonLogin: UpdateUI, completion: @escaping (LoginResultHaveData) -> ()) {
        let dictionary = makeParameter(username: userName, passwd: passWd)
        buttonLogin.disableUIButton()
        news.loadData(urlString: API.login, method: HTTPMethod.post, dic: dictionary, completion: { (object) in
            let errOr = object as? String ?? ""
            if errOr == "sai thong tin" {
                buttonLogin.enabledButton()
                completion(LoginResultHaveData.error(message: "Bạn nhập sai thông tin"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResultHaveData.success(data: user))
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
        var dic : [String: String] = [:]
        dic["phonenumber"] = username
        dic["passwd"]      = passwd
        return dic
    }
    func navigationPushHomeShop(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(TabBarHomeShop.self)
        viewControllerMain.getDataAfterLoginOrSign(numberPhone: data.phonenumber)
        view.pushVC(view: viewControllerMain)
    }
    func navigationPushHomeShipper(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(HomeShipper.self)
        view.pushVC(view: viewControllerMain)
    }
}
