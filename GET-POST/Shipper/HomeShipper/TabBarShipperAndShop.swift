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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationNewViewController = presenter?.navigationControllers else { return }
        viewControllers = navigationNewViewController
    }
}
