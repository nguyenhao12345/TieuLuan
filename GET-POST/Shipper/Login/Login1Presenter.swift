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
    func clickLogin(userName: String, passWd: String, view: PushPopNavigation, updateLable: UpdateUI, buttonLogin: UpdateUI) {
        let errMess = checkFullInfo(userName: userName, passWd: passWd)
        guard errMess == nil else {
            updateLable.updateUILableError(lable: errMess ?? "")
            return
        }
        let viewServiceLogin = instantiate(ServiceLogin.self)
        viewServiceLogin.inject(presenterServiceLogin: ServiceLoginPresenterImp.init(numberPhone: userName, passWd: passWd))
        view.present(view: viewServiceLogin)
    }
    
    func clickSign(view: PushPopNavigation) {
        let viewSigin = instantiate(Sign1.self, storyboard: "Sign1")
        view.pushVC(view: viewSigin)
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

}
