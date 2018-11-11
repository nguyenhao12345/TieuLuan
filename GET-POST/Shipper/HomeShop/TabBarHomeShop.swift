//
//  TabBarHomeShop.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/3/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class TabBarHomeShop: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        navigationController?.isNavigationBarHidden = true
     
    }
    private var numberPhone: String = ""
    
    func getDataAfterLoginOrSign(numberPhone: String) {
        self.numberPhone = numberPhone
    }
   
    private var newsController: CreateNewsController {
        let viewController = instantiate(CreateNewsController.self, storyboard: "CreateNewsController")
        viewController.inject(presenter: CreateNewsControllerImp(string: numberPhone))
        let createNewsController = UINavigationController(rootViewController: viewController)
        createNewsController.tabBarItem.title = TitleItemShop.CreateItems.rawValue //sua ten =CreateNewsController
        return viewController
    }
    private var listNewsController: ListNewsController {
        let listNewsControllerStoryboard = instantiate(ListNewsController.self, storyboard: "ListNewsController")
        let listNewsController = UINavigationController(rootViewController: listNewsControllerStoryboard)
        listNewsController.tabBarItem.title = TitleItemShop.ListItems.rawValue
        
        return listNewsControllerStoryboard
    }
    private var detailShopController: DetailShop {
        let detailShopControllerStoryboard = instantiate(DetailShop.self, storyboard: "DetailShop")
        let detailShopController = UINavigationController(rootViewController: detailShopControllerStoryboard)
        detailShopController.tabBarItem.title = TitleItemShop.Account.rawValue
        
        return detailShopControllerStoryboard
    }
    
    private func setupTabBar() {
        viewControllers = [newsController, listNewsController, detailShopController]
    }
}

