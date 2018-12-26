//
//  ViewController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/22/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

protocol ChangeViewController {
    func push(to viewController: UIViewController)
    func present(to viewController: UIViewController)
}

class SignInController: UIViewController {
    fileprivate let googleButton = GIDSignInButton()
    private var presenter: ViewControllerPresenter?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButton()
        setupButtonSignUp()
        presenter = ViewControllerPresenterImp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupButtonSignUp() {
        let labelSignUpY = googleButton.frame.origin.y + 65
        let textButtonSignUp = " Sign up"
        let heightTextButtonSignUp: CGFloat = 25
        let widthTextButtonSignUp = textButtonSignUp.width(constraintedHeight: heightTextButtonSignUp, font: UIFont.boldSystemFont(ofSize: 15))
        let labelSignUpX = googleButton.frame.origin.x + googleButton.frame.size.width / 2 - widthTextButtonSignUp / 2
        let textLabelSignUp = "Don't have an account?"
        let heightLabelSignUp: CGFloat = 20
        let widthLabelSignUp = textLabelSignUp.width(constraintedHeight: heightLabelSignUp, font: UIFont.italicSystemFont(ofSize: 15))
        let labelSignUp = UILabel(frame: CGRect(x: 0, y: 0, width: widthLabelSignUp, height: heightLabelSignUp))
        
        labelSignUp.center = CGPoint(x: labelSignUpX, y: labelSignUpY)
        labelSignUp.text = textLabelSignUp
        labelSignUp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelSignUp.font = UIFont.systemFont(ofSize: 15)
        labelSignUp.font = UIFont.italicSystemFont(ofSize: 15)
        view.addSubview(labelSignUp)
        
        let buttonSignUpY = labelSignUp.frame.origin.y - 2
        let buttonSignUpX = labelSignUp.frame.origin.x + labelSignUp.frame.size.width
        let buttonSignUp = UIButton(frame: CGRect(x: buttonSignUpX, y: buttonSignUpY, width: 70, height: 25))
       
        buttonSignUp.setTitle(textButtonSignUp, for: .normal)
        buttonSignUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        buttonSignUp.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(buttonSignUp)
        buttonSignUp.addTarget(self, action: #selector(SignUp), for: .touchUpInside)
    }
    
    @objc private func SignUp(sender: UIButton!) {
        presenter?.signUp(viewController: self)
    }
}

extension SignInController: GIDSignInUIDelegate {
    private func setupGoogleButton() {
        let googleButtonX: CGFloat = 50
        let googleButtonY = view.frame.height / 6 + view.frame.height / 2
        let googleButtonWidth = view.frame.width - 100
        let googleButtonHeight: CGFloat = 50
        
        googleButton.frame = CGRect(x: googleButtonX, y: googleButtonY, width: googleButtonWidth, height: googleButtonHeight)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
}

extension SignInController: ChangeViewController {
    func present(to viewController: UIViewController) {}
    
    func push(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
