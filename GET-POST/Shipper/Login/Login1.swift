//
//  Login1.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/21/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

protocol PushPopNavigation {
    func pushVC(view: UIViewController)
    func present(view: UIViewController)
    func popVC(view: UIViewController)
}

class Login1: UIViewController {
    
    @IBOutlet fileprivate weak var btnLogin:     UIButton!
    @IBOutlet fileprivate weak var activityLoad: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var mesError:     UILabel!
    @IBOutlet fileprivate weak var passwd:       UITextField!
    @IBOutlet fileprivate weak var username:     UITextField!
    
    private var presenter : Login1Presenter?
    
    @IBAction private func clickLoggin(_ sender: Any) {
        presenter?.clickLogin(userName: username.text ?? "", passWd: passwd.text ?? "", view: self, updateLable: self, buttonLogin: self)
        btnLogin.shake()
    }
    
    @IBAction private func clickSign(_ sender: Any) {
        presenter?.clickSign(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Login1PresenterImp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension Login1: PushPopNavigation {
    func popVC(view: UIViewController) {}
    
    func present(view: UIViewController) {
        present(view, animated: false)
    }
    
    func pushVC(view: UIViewController) {
        activityLoad.stopAnimating()
        guard let navigationController = navigationController else {
            present(view, animated: true, completion: nil)
            return
        }
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(view, animated: true)
    }
}


protocol UpdateUI {
    func updateUILableError(lable: String)
    func setUIImage() -> UIImage?
    func disableUIButton()
    func enabledButton()
    func updataUIImagePicker(image: UIImage)
}

extension Login1: UpdateUI {
    
    func updataUIImagePicker(image: UIImage) {}
    
    func disableUIButton() {
        activityLoad.startAnimating()
        btnLogin.isEnabled     = false
        btnLogin.isHighlighted = true
    }
    
    func enabledButton() {
        btnLogin.isEnabled     = true
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
