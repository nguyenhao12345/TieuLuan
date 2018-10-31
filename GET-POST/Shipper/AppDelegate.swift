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
        // Override point for customization after application launch.
         check()
        return true
    }
    func check() {
        if UserDefaults.standard.value(forKey: "phoneNumber") != nil {
            if  UserDefaults.standard.value(forKey: "typeAccount") as? String ?? "" == "Shop"{
                let vc = UIStoryboard(name: "HomeShop", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeShop")
                let navVC = UINavigationController(rootViewController: vc)
                navVC.navigationController?.isToolbarHidden = true
                let share = UIApplication.shared.delegate as? AppDelegate
                share?.window?.rootViewController = navVC
                share?.window?.makeKeyAndVisible()
            }
            if  UserDefaults.standard.value(forKey: "typeAccount") as? String ?? "" == "Shipper"{
                guard let vc = UIStoryboard(name: "HomeShipper", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeShipper") as? HomeShipper else { return }
                let navVC = UINavigationController(rootViewController: vc)
                navVC.navigationController?.isToolbarHidden = true
                let share = UIApplication.shared.delegate as? AppDelegate
                share?.window?.rootViewController = navVC
                share?.window?.makeKeyAndVisible()
            }
        }
       
//        else {
//            let vc = UIStoryboard(name: "Login1", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login1")
//            let navVC = UINavigationController(rootViewController: vc)
//            let share = UIApplication.shared.delegate as? AppDelegate
//            share?.window?.rootViewController = navVC
//            share?.window?.makeKeyAndVisible()
//        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

