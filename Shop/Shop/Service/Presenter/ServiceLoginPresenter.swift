//
//  ServiceLoginPresenter.swift
//  Shop
//
//  Created by Nguyen Hieu on 11/24/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit
protocol ServiceLoginPresenter {
    func loginSucess(view: UIViewController)
}
class ServiceLoginPresenterImp: FirebaseService, ServiceLoginPresenter {
    private var email: String = ""
    private var pass: String = ""
    private var uid: String = ""
//    private var uIdUserDefault = UserDefaults.standard.value(forKey: "UID")
    init(email: String, pass: String, uid: String) {
        self.email = email
        self.pass  = pass
        self.uid = uid
    }

    func loginSucess(view: UIViewController) {
        if uid == "" {
            FirebaseService.share.checkLogin(email: email, pass: pass) { (result) in
                switch result {
                case .success(let data):
                    UserDefaults.standard.set(data.user.uid, forKey: "UID")
                    let viewTabbar = TabBarShipperAndShop.create(uID: data.user.uid)
                    DispatchQueue.main.async {
                        view.present(viewTabbar, animated: true, completion: nil)
                        print(UserDefaults.standard.value(forKey: "UID"))
                    }
                case .error(let message):
                    print(message)
                    view.dismiss(animated: false, completion: nil)
                }
            }
        }
        else {
            FirebaseService.share.checkLogin(with: uid) { (result) in
                switch result {
                case "thành công":
                    let viewTabbar = TabBarShipperAndShop.create(uID: self.uid)
                    DispatchQueue.main.async {
                        view.present(viewTabbar, animated: true, completion: nil)
                    }
                case "thất bại":
                    print("that bại")
                default:
                    break
                }
            }
        }
       
    }
    func parseDataOf(uid: String,  completion: @escaping (String) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Login").child(uid).observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let urlImg = value?["avata"] as? String ?? ""
            completion(urlImg)
        }
    }
}
