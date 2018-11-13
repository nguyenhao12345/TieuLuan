//
//  ServiceLogin.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/11/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit

class ServiceLogin: UIViewController {
    
    @IBOutlet weak var loadImageGif: UIImageView!
    private var presenterServiceLogin: ServiceLoginPresenter?
    func inject(presenterServiceLogin: ServiceLoginPresenter){
        self.presenterServiceLogin = presenterServiceLogin
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageGif = UIImage.gifImageWithName(name: "w4lCH3c-2")
        loadImageGif.image = imageGif
       
        presenterServiceLogin?.loginSucess(viewDismis: self, viewPresent: self)
    }
    
}
protocol Dismis {
    func dismis()
}
extension ServiceLogin: Dismis {
    func dismis() {
        self.dismiss(animated: false, completion: nil)
    }
}
extension ServiceLogin: PushPopNavigation {
    func pushVC(view: UIViewController) {}
    
    func present(view: UIViewController) {
        self.present(view, animated: false, completion: nil)
    }
    
    func popVC(view: UIViewController) {}
}
