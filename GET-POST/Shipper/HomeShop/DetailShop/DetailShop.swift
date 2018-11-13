//
//  DetailShop.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/3/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit


class DetailShop: UIViewController,ViewControllerTabar {
    
    @IBOutlet weak fileprivate var passwdShop:      UITextField!
    @IBOutlet weak fileprivate var numberPhoneShop: UITextField!
    @IBOutlet weak fileprivate var nameShop:        UITextField!
    @IBOutlet weak fileprivate var imgShop:         UIView!
    
    var nameBar: String {
        return "Tài khoản"
    }
    
    var presenter: DetailShopPresenter?
    @IBAction func clickLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel,handler:{ (action:UIAlertAction) in
        }))
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            UserDefaults.standard.removeObject(forKey: "numberPhone")
            
            
            //            (UIApplication.shared.delegate as? AppDelegate)?.whateverWillOccur()
        }))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DetailShopPresenterImp()
    }
    
    
    
    
}
