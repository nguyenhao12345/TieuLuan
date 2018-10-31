//
//  HomeShipper.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/27/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class HomeShipper: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let newViewStoryboard = UIStoryboard(name: "NewViewController", bundle: nil)
        guard let newViewController =  newViewStoryboard.instantiateViewController(withIdentifier: "newViewController") as? NewViewController else { return }
        let navigationNewViewController = UINavigationController(rootViewController: newViewController)
        navigationNewViewController.tabBarItem.title = "Mới nhất"
        let storageViewStroryboard = UIStoryboard(name: "StorageViewController", bundle: nil)
        guard let storageViewController = storageViewStroryboard.instantiateViewController(withIdentifier: "storageViewController") as? StorageViewController else { return }
        let navigationStorageViewController = UINavigationController(rootViewController: storageViewController)
        navigationStorageViewController.tabBarItem.title = "Lưu trữ"
        let accountViewStoryboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        guard let accountViewController = accountViewStoryboard.instantiateViewController(withIdentifier: "accountViewController") as? AccountViewController else { return }
        let navigationAccountViewController = UINavigationController(rootViewController: accountViewController)
        navigationAccountViewController.tabBarItem.title = "tài khoản"
        let createViewStoryboard = UIStoryboard(name: "CreateViewController", bundle: nil)
        guard let createViewController = createViewStoryboard.instantiateViewController(withIdentifier: "createViewController") as? CreateViewController else { return }
        let navigationCreateViewController = UINavigationController(rootViewController: createViewController)
        navigationCreateViewController.tabBarItem.title = "Tạo mới"
        viewControllers = [navigationNewViewController, navigationStorageViewController, navigationAccountViewController, navigationCreateViewController]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}
