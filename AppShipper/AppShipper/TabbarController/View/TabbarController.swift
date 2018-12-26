//
//  NewsController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/27/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class TabbarController: UITabBarController {
    private var presenter: RootTabbarController?
    
    func inject(presenterRootTabbarController: RootTabbarController) {
        self.presenter = presenterRootTabbarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        guard let navigationController = presenter?.navigationControllers else { return }
        viewControllers = navigationController
    }
}
