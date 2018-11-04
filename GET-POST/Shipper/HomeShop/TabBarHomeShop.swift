//
//  TabBarHomeShop.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/3/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
protocol InjectProtocol {
    func config()
}
extension TabBarHomeShop: InjectProtocol {
    func config() {
        
    }
}
class TabBarHomeShop: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
     
    }
    private var numberPhone: String = ""
    func getDataAfterLoginOrSign(numberPhone: String) {
        self.numberPhone = numberPhone
    }
   
    private func setupTabBar() {
        let createNewsControllerStoryboard = instantiate(CreateNewsController.self, storyboard: "CreateNewsController")
        createNewsControllerStoryboard.presenter = CreateNewsControllerImp()
        CreateNewsControllerImp().getDataAfterLogin(phone: numberPhone)
        
        let createNewsController = UINavigationController(rootViewController: createNewsControllerStoryboard)
        createNewsController.tabBarItem.title = TitleItemShop.CreateItems.rawValue
       
        
        let listNewsControllerStoryboard = instantiate(ListNewsController.self, storyboard: "ListNewsController")
        let listNewsController = UINavigationController(rootViewController: listNewsControllerStoryboard)
        listNewsController.tabBarItem.title = TitleItemShop.ListItems.rawValue
        
        
        let detailShopControllerStoryboard = instantiate(DetailShop.self, storyboard: "DetailShop")
        let detailShopController = UINavigationController(rootViewController: detailShopControllerStoryboard)
        detailShopController.tabBarItem.title = TitleItemShop.Account.rawValue
        
        viewControllers = [createNewsController,listNewsController,detailShopController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title {
        case TitleItemShop.CreateItems.rawValue:
            print("mh1")
            break
        case TitleItemShop.ListItems.rawValue:
            print("mh2")
             break
        case TitleItemShop.Account.rawValue:
            print("mh3")
             break
        default:
            break
        }
    }
}
enum TitleItemShop: String {
    case CreateItems = "Tạo đơn"
    case ListItems = "Danh sách"
    case Account = "Tài khoản"
    
}

