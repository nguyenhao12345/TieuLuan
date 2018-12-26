//
//  AppDelegate.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/22/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    let userDefault = UserDefaults()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        checkLogined()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    private func checkLogined() {
        if let uID = UserDefaults.standard.value(forKey: "userSignedIn") as? String {
            let tabbarController = instantiate(TabbarController.self)
            tabbarController.inject(presenterRootTabbarController: RootTabbarControllerImp(uID: uID))
            tabbarController.rootUIStoryBoard()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        } else {
            FireBaseService.share.logout()
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) {[weak self] (result, error) in
                if error == nil {
                    FireBaseService.share.getData(with: "Login", completion: { (value) in
                        let logins = GetLogins(data: value as? [String: [String: Any]] ?? [:])
                        guard let uID = result?.user.uid else { return }
                        for login in logins.getLogins() {
                            if login.getUID() == uID {
                                DispatchQueue.main.async {
                                    self?.userDefault.set(uID, forKey: "userSignedIn")
                                    let tabbarController = instantiate(TabbarController.self)
                                    tabbarController.inject(presenterRootTabbarController: RootTabbarControllerImp(uID: uID ?? ""))
                                    tabbarController.rootUIStoryBoard()
                                }
                            } 
                        }
                    })
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
}
