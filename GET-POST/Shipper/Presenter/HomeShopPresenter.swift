//
//  HomeShopPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/11/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

//protocol HomeShopPresenter {
//    var navigationControllers: [UINavigationController] { get }
//}

class HomeShopPresenterImp: RootTabBarController {
    private var numberPhone: String = ""
    
    init(numberPhoneUser: String) {
        numberPhone = numberPhoneUser
    }
    
    private var viewControllers: [ViewControllerTabar] {
        let newViewStoryboard        = instantiate(CreateNewsController.self)
        newViewStoryboard.inject(presenter: CreateNewsControllerImp(string: numberPhone))
        
        let listNewsController     = instantiate(ListNewsController.self)
        
        let detailShopController   = instantiate(DetailShop.self)
        
        return [newViewStoryboard, listNewsController, detailShopController]
    }
    
    var navigationControllers: [UINavigationController] {
        return viewControllers.map {
            let navigationController = UINavigationController(rootViewController: $0 as? UIViewController ?? UIViewController())
            navigationController.tabBarItem.title = $0.nameBar
            return navigationController
        }
    }
}
