//
//  HomeShopPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/11/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
//của chung
protocol RootTabBarController { //sua ten roottabbarcontroller
    var navigationControllers: [UINavigationController] { get }
}

class HomeShopPresenterImp: RootTabBarController {
    private var uID: String = ""
    
    init(uID: String) {
        self.uID = uID
    }
    
    private var viewControllers: [ViewControllerTabar] {
        let newViewStoryboard        = instantiate(CreateNewsController.self)
        newViewStoryboard.presenterCreateNews = CreateNewsControllerPresenterImp.init(uid: uID)
//        newViewStoryboard.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        
        let listNewsController     = instantiate(ListNewsController.self)
        listNewsController.inject(presenter: ListNewsPresenterImp(uidShop: uID))
//        listNewsController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        let detailShopController   = instantiate(DetailShop.self)
//        detailShopController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        
        return [newViewStoryboard, listNewsController, detailShopController]
    }
    
    var navigationControllers: [UINavigationController] {
        return viewControllers.map {
            let navigationController = UINavigationController(rootViewController: $0 as? UIViewController ?? UIViewController())
            navigationController.tabBarItem = UITabBarItem(title: $0.nameBar, image: $0.image, tag: $0.index)
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
    }
}
