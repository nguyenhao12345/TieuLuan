//
//  SignPresenter.swift
//  Shop
//
//  Created by Nguyen Hieu on 11/25/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase
import UIKit
import FirebaseStorage

protocol SignPresenter {
    func registAccount(email: String, pass: String, fullname: String, phonenumber: String, typeAccount: Int, identifi: String, image: GetDataFormUIPicker)
    func clickCamera(view: PushPopNavigation)
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any], updataUIImage: UpdateUI)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
}
let ref: DatabaseReference = Database.database().reference()
class SignPresenterImp: SignPresenter {
    
    //chọn hình từ camera or lib
    func clickCamera(view: PushPopNavigation) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let actionSheet = UIAlertController(title: "Photos", message: "Choose a Source", preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            view.present(view: imagePickerController)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            view.present(view: imagePickerController)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view.present(view: actionSheet)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any], updataUIImage: UpdateUI) {
        print("aaaaa")
        
        if let image = info[.originalImage] as?  UIImage {
            updataUIImage.updataUIImagePicker(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func registAccount(email: String, pass: String, fullname: String, phonenumber: String,  typeAccount: Int, identifi: String, image: GetDataFormUIPicker) {
        createAccount(withEmail: email, withPasswd: pass) { (resultCreateAccount) in
            switch resultCreateAccount {
            case .error(let message):
                print(message)
            case .success(let dataUser):
                // Create a root reference
                let storageRef = Storage.storage().reference()
                // Data in memory
                guard let data = image.getImageFromUIPicker()?.jpegData(compressionQuality: 0.1)
                    else { return }
                // Create a reference to the file you want to upload
                let imageRef = storageRef.child("images/\(dataUser.uid).jpg")
                // Upload the file to the path
                DispatchQueue.main.async {
                    imageRef.putData(data, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            return
                        }
                        imageRef.downloadURL(completion: { (url, error) in
                            guard let url = url else { return }
                            
                            let dic = ["UID": dataUser.uid,
                                       "Phonenumber": phonenumber,
                                       "fullName": fullname,
                                       "IdTypeAccount": typeAccount,
                                       "CMND": identifi,
                                       "avata": url.absoluteString] as [String : Any] 
                            DispatchQueue.main.async {
                                ref.child("Login").child(dataUser.uid).setValue(dic)
                                print(metadata.path ?? "")
                            }
                        })
                    }
                }
                //chuyeenr man hinh ->>>> tabbar
            }
        }
    }
    private func createAccount(withEmail email: String, withPasswd pass: String, completion: @escaping (LoginResult) -> ()) {
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            if let user = authResult?.user {
                completion(LoginResult.success(dataUser: user))
            }
            else {
                completion(LoginResult.error(message: error?.localizedDescription ?? ""))
            }
        }
        
    }
    enum LoginResult {
        case error(message: String)
        case success(dataUser: User)
    }}
