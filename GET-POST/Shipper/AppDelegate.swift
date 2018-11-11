//
//  AppDelegate.swift
//  GET-POST
//
//  Created by datnguyen on 10/3/16.
//  Copyright © 2016 datnguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        checkLogined()
        return true
    }
    
    func checkLogined() {
        if let sdt = UserDefaults.standard.value(forKey: "numberPhone") {
            let viewController = instantiate(ServiceLogin.self)
            guard let sdtExport = sdt as? String else { return }
            viewController.inject(presenterServiceLogin: ServiceLoginPresenterImp.init(numberPhone: sdtExport, passWd: nil))
            viewController.rootUIStoryboard()
        } else {
            let viewController = instantiate(Login1.self)
            viewController.rootUIStoryboard()
        }
        
        
//        let viewController = instantiate(TabBarHomeShop.self)
//        let presenter = isLogin ? presenterImplHao() : presenterImplHieu()
//        viewController.rootUIStoryboard()
    }
}

