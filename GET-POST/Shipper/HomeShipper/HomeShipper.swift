//
//  HomeShipper.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/27/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class HomeShipper: UITabBarController {
    private var presenter: HomeShiperPresenter?
    private let ArrayInfoTabBar = [ModelTabBarItemScreenShiper(nameViewController: "NewViewController", withIdentifier: "newViewController", title: "Mới nhất", nameViewControllerScreenShiper: .NewViewController), ModelTabBarItemScreenShiper(nameViewController: "StorageViewController", withIdentifier: "storageViewController", title: "Lưu trữ", nameViewControllerScreenShiper: .StorageViewController), ModelTabBarItemScreenShiper(nameViewController: "AccountViewController", withIdentifier: "accountViewController", title: "Tài khoản", nameViewControllerScreenShiper: .AccountViewController), ModelTabBarItemScreenShiper(nameViewController: "CreateViewController", withIdentifier: "createViewController", title: "Tạo mới", nameViewControllerScreenShiper: .CreateViewController)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomeShiperPresenterImp()
        guard let navigationNewViewController = presenter?.createNavigationController(ArrayInfoTabBar: ArrayInfoTabBar) else { return }
        
        viewControllers = navigationNewViewController
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}
