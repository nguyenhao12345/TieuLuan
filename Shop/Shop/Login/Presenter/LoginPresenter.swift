//
//  LoginPresenter.swift
//  Shop
//
//  Created by Nguyen Hieu on 11/24/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import Foundation
import FirebaseAuth
enum LoginResul {
    case error(message: String)
    case success(data: AuthDataResult)
}

protocol LoginPresenter {
    func moveToServiceLogin(email: String, pass: String, view: MoveScreenOfLoginStoryboard)
}
class LoginPresenterImp: LoginPresenter {

    func moveToServiceLogin(email: String, pass: String, view: MoveScreenOfLoginStoryboard) {
        let viewServiceLogin = instantiate(ServiceLogin.self)
        viewServiceLogin.inject(presenter: ServiceLoginPresenterImp.init(email: email, pass: pass, uid: ""))
        view.present(view: viewServiceLogin)
    }
}
struct AccountLogin {
    var numberPhone: [Account]
    init(data: [String: Any]) {
        let jsons = data["Login"] as? [String: [String: Any]] ?? [:]
        numberPhone = jsons.map { Account(data: $0.value) }
    }
    
    struct Account {
        var phoneNumber: String
        var passWd: String
        var image: String
        var idTypeAccount: Int
        var CMND: String
        init(data: [String: Any]) {
            self.phoneNumber = data["phoneNumber"] as? String ?? ""
            self.passWd = data["passWd"] as? String ?? ""
            self.image = data["Image"] as? String ?? ""
            self.CMND = data["CMND"] as? String ?? ""
            self.idTypeAccount = data["IdTypeAccount"] as? Int ?? 0
        }
    }
}

struct TypeAccount {
    var idTypeAccount: Int
    var nameTypeAccount: String
    init(data: [String: Any]) {
        self.idTypeAccount = data["IdTypeAccount"] as? Int ?? 0
        self.nameTypeAccount = data["NameTypeAccount"] as? String ?? ""
    }
}
