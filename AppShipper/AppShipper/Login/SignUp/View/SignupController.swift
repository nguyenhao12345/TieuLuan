//
//  EnterPhoneNumberController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/23/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    @IBOutlet weak private var buttonChooseCity: UIButton!
    @IBOutlet weak private var textFieldFullName: UITextField!
    @IBOutlet weak private var textFieldPhoneNumber: UITextField!
    @IBOutlet weak private var textFieldEmail: UITextField!
    @IBOutlet weak private var textFieldCardId: UITextField!
    @IBOutlet weak private var textfieldPassword: UITextField!
    private var presenter: SignUpControllerPresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignUpControllerPresenterImp()
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction private func buttonChooseCity(_ sender: Any) {
        let titleArletActions = ["Hà Nội", "Hồ Chí Minh"]
        createActionSheet(titleActionSheet: "Choose city", messageActionSheet: "", titleArletActions: titleArletActions)
    }
    
    
    @IBAction private func buttonCreate(_ sender: Any) {
        var paramInfoUser = [String: Any]()
        let idTypeShipper = 2
        let passwordUser = textfieldPassword.text ?? ""
        let emailUser = textFieldEmail.text ?? ""
        
        paramInfoUser["CMND"] = textFieldCardId.text
        paramInfoUser["IdTypeAccount"] = idTypeShipper
        paramInfoUser["Phonenumber"] = textFieldPhoneNumber.text
        paramInfoUser["fullName"] = textFieldFullName.text
        presenter?.createInfo(with: paramInfoUser, emailUser: emailUser, passwordUer: passwordUser, viewController: self)
    }
    
    private func createActionSheet(titleActionSheet: String, messageActionSheet: String, titleArletActions: [String]) {
        let actionSheet = UIAlertController(title: titleActionSheet, message: messageActionSheet, preferredStyle: .actionSheet)
        
        titleArletActions.map { actionSheet.addAction(UIAlertAction(title: $0, style: .default, handler: { [weak self] (action: UIAlertAction) in
            self?.ChangeTitleButtonChooseCity(text: action.title ?? "")
        }))}
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func ChangeTitleButtonChooseCity(text: String) {
        buttonChooseCity.setTitle(text, for: .normal)
    }
}

extension SignUpController: ChangeViewController {
    func present(to viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func push(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SignUpController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
