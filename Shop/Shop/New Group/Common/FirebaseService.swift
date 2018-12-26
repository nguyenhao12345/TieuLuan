//
//  FirebaseService.swift
//  Shop
//
//  Created by Nguyen Hieu on 12/9/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//


import Foundation
import FirebaseAuth
import Firebase
import UIKit
import FirebaseStorage

class FirebaseService {
    static let share = FirebaseService()
    
     var ref: DatabaseReference =  Database.database().reference()
    
    func checkLogin(with uid: String, completion: @escaping (String) -> ()) {
        ref.child("Login").child(uid).observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                print(value)
                completion("thành công")
                
            }
            else {
//            print(value)
                completion("thất bại")
            }
        }
    }
    
     func checkLogin(email: String, pass: String, completion: @escaping (LoginResul) -> ()) {
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if let user = user {
                completion(LoginResul.success(data: user))
            }
            else {
                completion(LoginResul.error(message: error?.localizedDescription ?? ""))
            }
        }
    }
     func paserDataFormFirebaseWith(root: String, uid: String, completion: @escaping (String) -> ()) {
        ref.child("Login").child(uid).observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let urlImg = value?["avata"] as? String ?? ""
            completion(urlImg)
        }
    }
}
