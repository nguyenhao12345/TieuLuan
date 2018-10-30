//
//  Login1.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/21/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class Login1: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var activityLoad: UIActivityIndicatorView!
    @IBOutlet weak var mesError: UILabel!
    @IBOutlet private weak var passwd: UITextField!
    @IBOutlet private weak var username: UITextField!
    var presenter : Login1Presenter?
    var istouch = false
    @IBAction private func clickLoggin(_ sender: Any) {
        presenter?.clickLogin(userName: username.text ?? "", passWd: passwd.text ?? "", view: self, updateLable: self,buttonLogin: self)
        btnLogin.shake()
    }

    @IBAction private func clickSign(_ sender: Any) {
        presenter?.clickSign(view: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Login1PresenterImp()
        let homeShop = HomeShopPresenterImp()
        guard  let presenterExport = presenter as? HomeShopPresenterDelegate  else {
            return
        }
        homeShop.delegate = presenterExport

        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
protocol PushPopNavigation {
    func pushVC(view: UIViewController)
    func present(view: UIViewController)
    func popVC(view: UIViewController)
}
extension Login1: PushPopNavigation {
    func popVC(view: UIViewController) {
        
    }
    
    func present(view: UIViewController) {
        
    }
    
    func pushVC(view: UIViewController) {
        activityLoad.stopAnimating()
        guard let navigationController = navigationController else {
            present(view, animated: true, completion: nil)
            return
        }
        navigationController.pushViewController(view, animated: true)
    }
}
protocol UpdateUI {
    func updateUILableError(lable: String)
    func setUIImage() -> UIImage?
    func updataUIButton()
    func enabledButton()
    func updataUIImagePicker(image: UIImage)
   
  
}
extension Login1: UpdateUI {

    
   func updataUIImagePicker(image: UIImage) {
    }
    func updataUIButton() { //disable btn
        activityLoad.startAnimating()
        btnLogin.isEnabled = false
        btnLogin.isHighlighted = true
    }
    func enabledButton() { // bật lại đc bấm
        btnLogin.isEnabled = true
        activityLoad.stopAnimating()
    }
    func setUIImage() -> UIImage? {
        return UIImage()
    }
    func updateUILableError(lable: String)  {
        mesError.text = lable
    }
}
extension Login1: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
