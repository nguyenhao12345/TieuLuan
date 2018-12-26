//
//  HomeShipper.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/27/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class TabBarShipperAndShop: UITabBarController {
  private var presenter: RootTabBarController?
    func injection(to presenterShop: RootTabBarController?) {
        self.presenter = presenterShop
    }
    
    func setupViewControllers() {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationNewViewController = presenter?.navigationControllers else { return }
        viewControllers = navigationNewViewController
        self.navigationController?.isNavigationBarHidden = true
    }

 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension TabBarShipperAndShop {
    static func create(uID: String) -> TabBarShipperAndShop {
        let viewTabbar = instantiate(TabBarShipperAndShop.self)
        viewTabbar.injection(to: HomeShopPresenterImp(uID: uID))
        viewTabbar.setupViewControllers()
        
        return viewTabbar
    }
}
