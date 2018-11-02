//
//  HomeShiperPresenter.swift
//  GET-POST
//
//  Created by HaoNguyen on 11/2/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

protocol HomeShiperPresenter {
    func createNavigationController(ArrayInfoTabBar: [ModelTabBarItemScreenShiper]) -> [UINavigationController]
}

class HomeShiperPresenterImp: HomeShiperPresenter {
    private func createViewController(nameViewController: String, withIdentifier: String, nameViewControllerScreenShiper: NameViewControllerScreenShiper) -> UIViewController {
        switch nameViewControllerScreenShiper {
        case .NewViewController:
            let newViewStoryboard = UIStoryboard(name: nameViewController, bundle: nil)
            guard let newViewController =  newViewStoryboard.instantiateViewController(withIdentifier: withIdentifier) as? NewViewController else { return UIViewController()}
            
            return newViewController
        case .StorageViewController:
            let storageViewStroryboard = UIStoryboard(name: nameViewController, bundle: nil)
            guard let storageViewController = storageViewStroryboard.instantiateViewController(withIdentifier: withIdentifier) as? StorageViewController else { return UIViewController()}
            
            return storageViewController
        case .CreateViewController:
            let createViewStoryboard = UIStoryboard(name: nameViewController, bundle: nil)
            guard let createViewController = createViewStoryboard.instantiateViewController(withIdentifier: withIdentifier) as? CreateViewController else { return UIViewController()}
            
            return createViewController
        case .AccountViewController:
            let accountViewStoryboard = UIStoryboard(name: nameViewController, bundle: nil)
            guard let accountViewController = accountViewStoryboard.instantiateViewController(withIdentifier: withIdentifier) as? AccountViewController else { return UIViewController()}
            
            return accountViewController
        }
    }
    
    func createNavigationController(ArrayInfoTabBar: [ModelTabBarItemScreenShiper]) -> [UINavigationController] {
        var navigationController: [UINavigationController] = []
        
        for value in ArrayInfoTabBar {
            let viewController = createViewController(nameViewController: value.getNameViewController(), withIdentifier: value.getwithIdentifier(), nameViewControllerScreenShiper: value.getNameViewControllerScreenShiper())
            let navigationViewController = UINavigationController(rootViewController: viewController)
            
            navigationViewController.tabBarItem.title = value.getTitle()
            navigationController.append(navigationViewController)
        }
        return navigationController
    }
}
