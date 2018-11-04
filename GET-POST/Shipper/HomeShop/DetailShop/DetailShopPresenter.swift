//
//  DetailShopPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/4/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit

protocol DetailShopPresenter {
    func clickLoutout(view: PushPopNavigation)
}
class DetailShopPresenterImp: DetailShopPresenter {
    func clickLoutout(view: PushPopNavigation) {
        
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        view.present(view: alert)
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel,handler:{ (action:UIAlertAction) in
        }))
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            UserDefaults.standard.removeObject(forKey: "phoneNumber")
            UserDefaults.standard.removeObject(forKey: "typeAccount")
            let vc = UIStoryboard(name: "Login1", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login1")
            let navVC = UINavigationController(rootViewController: vc)
            let share = UIApplication.shared.delegate as? AppDelegate
            share?.window?.rootViewController = navVC
            share?.window?.makeKeyAndVisible()
        }))
    }
}
