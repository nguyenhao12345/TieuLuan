//
//  ExtensionUIViewController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/24/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func rootUIStoryBoard() {
        guard let share = UIApplication.shared.delegate as? AppDelegate else { return }
        let navigationController = UINavigationController(rootViewController: self)
        share.window?.rootViewController = navigationController
        share.window?.makeKeyAndVisible()
    }
}
