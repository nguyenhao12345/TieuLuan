//
//  SignUpControllerPesenter.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/25/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit
import Firebase

protocol SignUpControllerPresenter {
    func createInfo(with paramInfoUser: [String: Any], emailUser: String, passwordUer: String, viewController: ChangeViewController)
}

class SignUpControllerPresenterImp: SignUpControllerPresenter {
    private let userDefault = UserDefaults()
    func createInfo(with paramInfoUser: [String: Any], emailUser: String, passwordUer: String, viewController: ChangeViewController) {
        let ref = Database.database().reference()
        Auth.auth().createUser(withEmail: emailUser, password: passwordUer) {[weak self] (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let uidUserOption = user?.user.uid
                guard let uidUser = uidUserOption else { return }
                var paramInfoUserExtra = paramInfoUser
    
                paramInfoUserExtra["UID"] = uidUser
                paramInfoUserExtra["avata"] = ""
                ref.child("Login").updateChildValues([uidUser: paramInfoUserExtra])
                self?.userDefault.set(true, forKey: "userSignedIn")
                self?.changeView(to: viewController, with: uidUser)
            }
        }
    }
    
    private func changeView(to viewController: ChangeViewController, with uID: String) {
        DispatchQueue.main.async {
            let tabbarController = instantiate(TabbarController.self)
            tabbarController.inject(presenterRootTabbarController: RootTabbarControllerImp(uID: uID))
            tabbarController.rootUIStoryBoard()
        }
    }
}


