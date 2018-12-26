//
//  RootTabbarController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/27/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

protocol RootTabbarController {
    var navigationControllers: [UINavigationController] { get }
}

class RootTabbarControllerImp: RootTabbarController {
    private var uID: String
    
    init(uID: String) {
        self.uID = uID
    }
    
    var navigationControllers: [UINavigationController] {
        return viewController.map {
            let navigationController = UINavigationController(rootViewController: $0 as? UIViewController ?? UIViewController())
            
            navigationController.tabBarItem.title = $0.titleBar
            navigationController.tabBarItem.image = UIImage(named: $0.imageBar)
            return navigationController
        }
     }
    
    private var viewController: [ViewControllerTabar] {
        let newsController = instantiate(NewsController.self)
        newsController.inject(presenterNewsController: NewsControllerPresenterImp(uID: uID))
        let storageController = instantiate(StorageController.self)
        storageController.inject(storageControllerPresenter: StorageControllerPresenterImp(uID: uID))
        let routeController = instantiate(RouteController.self)
        routeController.inject(routeControllerPresenter: RouteControllerPresenterImp(uID: uID))
        let accountController = instantiate(AccountController.self)
        return [newsController, storageController, routeController, accountController]
    }
}
