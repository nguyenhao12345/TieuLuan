//
//  FireBaseService.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/4/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class FireBaseService {
    static var share = FireBaseService()
    
    private let ref = Database.database().reference()
    

    
    func getRef() -> DatabaseReference {
        return ref
    }
    
    func getData(with child: String, completion: @escaping (Any?) -> ()) {
        ref.child(child).observe(.value) { (snapshot) in
            completion(snapshot.value)
        }
    }
    
    func getDataHaveManyChild(with childs: [String], completion: @escaping (Any?) -> ()) {
        var refChild = ref
        
        for child in childs {
            refChild = refChild.child(child)
        }
        
        refChild.observe(.value) { (snapshot) in
            completion(snapshot.value)
        }
    }
    
    func logout() {
        let userDefault = UserDefaults()
        userDefault.removeObject(forKey: "userSignedIn")
        try? Auth.auth().signOut()
        GIDSignIn.sharedInstance()?.signOut()
    }
}
