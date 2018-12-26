//
//  AccountController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/27/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

class AccountController: UIViewController, ViewControllerTabar {
    var titleBar: String {
        return "Account"
    }
    
    var imageBar: String {
        return "account"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        FireBaseService.share.logout()
        let signInController = instantiate(SignInController.self, storyboard: "SignInController")
        
        present(signInController, animated: true, completion: nil)
    }
}
