//
//  HomeShiperPresenter.swift
//  GET-POST
//
//  Created by HaoNguyen on 11/2/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

protocol RootTabBarController { //sua ten roottabbarcontroller
    var navigationControllers: [UINavigationController] { get }
}

class HomeShiperPresenterImp: RootTabBarController {
    //let viewControllersClass = [NewViewController.self,
                                //StorageViewController.self,
                                //CreateViewController.self,
                                //AccountViewController.self]
    
//    func getDataAfterLoginOrSign(numberPhone: String) {
//        self.numberPhone = numberPhone
//    }
    private var viewControllers: [ViewControllerTabar] {
            let newViewStoryboard      = instantiate(NewViewController.self)
            let storageViewStroryboard = instantiate(StorageViewController.self)
            let createViewStoryboard   = instantiate(CreateViewController.self)
            let accountViewStoryboard  = instantiate(AccountViewController.self)

        return [newViewStoryboard, storageViewStroryboard, createViewStoryboard, accountViewStoryboard]

        //return viewControllersClass.map { instantiate($0) as? ViewControllerTabar }.compactMap { $0 }
    }
    
    var navigationControllers: [UINavigationController] {
        return viewControllers.map {
            let navigationController = UINavigationController(rootViewController: $0 as? UIViewController ?? UIViewController())
            
            navigationController.tabBarItem.title = $0.nameBar
            return navigationController
        }
    }
}
