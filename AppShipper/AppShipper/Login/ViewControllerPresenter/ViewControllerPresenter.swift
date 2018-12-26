//
//  ViewControllerPresenter.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/24/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation

protocol ViewControllerPresenter {
    func signUp(viewController: ChangeViewController)
}

class ViewControllerPresenterImp: ViewControllerPresenter {
    func signUp(viewController: ChangeViewController) {
        let signUpController = instantiate(SignUpController.self)
        viewController.push(to: signUpController)
    }
}
