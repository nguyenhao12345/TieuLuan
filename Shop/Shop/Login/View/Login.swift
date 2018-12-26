//
//  Login.swift
//  Shop
//
//  Created by Nguyen Hieu on 11/22/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
protocol MoveScreenOfLoginStoryboard {
    func present(view: UIViewController)
}
extension Login: MoveScreenOfLoginStoryboard {
    func present(view: UIViewController) {
        self.present(view, animated: false, completion: nil)
    }
}
extension Login: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
class Login: UIViewController {
    
    @IBOutlet fileprivate weak var phoneNumberTextField: UITextField!
    @IBOutlet fileprivate weak var passwdTextField: UITextField!
    
    private var presenter: LoginPresenter?
    @IBAction private func clickLogin(_ sender: Any) {
        guard let email = phoneNumberTextField.text,
                let pass  = passwdTextField.text else { return }
        presenter?.moveToServiceLogin(email: email, pass: pass, view: self)
    }
    
    @IBAction private func clickSign(_ sender: Any) {
        let viewControllerSign = Sign.create()
        
        self.present(viewControllerSign, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenterImp()
        //check ng dùng login
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if let user = user {
//                // lấy ra info ng dùng
//                print("da dang nhap \(user.email)")
//                print(user.uid)
//            }
//            else {
//                print("chua dang nhap ")
//            }
//        }
        navigationController?.isNavigationBarHidden = true
    }
}
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        ref.observe(DataEventType.value) { (snapshot) in
//
//            let dicdata: Dictionary<String,Any> = snapshot.value as! Dictionary<String,Any>
////            guard let jsonObject = try? JSONSerialization.jsonObject(with: snapshot, options: JSONSerialization.ReadingOptions.allowFragments),
////                let dataNews = jsonObject as? [String: Any] else { return }
//
//            let dataLogin = AccountLogin(data: dicdata)
//
//            print(dataLogin)
//        }
