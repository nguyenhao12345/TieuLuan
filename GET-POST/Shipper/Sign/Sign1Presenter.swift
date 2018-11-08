//
//  Sign1Presenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/23/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit

protocol Sign1Presenter {
    func clickSign(image: UpdateUI, userName: String, passWd: String, repasswd: String, firstAndLastName: String, typeUser: String, view: PushPopNavigation, updateLable: UpdateUI, updateUIButton: UpdateUI)
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], updataUIImage: UpdateUI)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    func clickCamera(view: PushPopNavigation)
    func clickBack(view: PushPopNavigation)
}
class Sign1PresenterImp: Sign1Presenter {
    
    private let news = Service()
    
    func clickBack(view: PushPopNavigation) {
        let viewControllerMain = instantiate(Login1.self, storyboard: "Login1")
        view.popVC(view: viewControllerMain)
    }
    
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
    
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], updataUIImage: UpdateUI) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        updataUIImage.updataUIImagePicker(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkRepasswd(passwd: String, repasswd: String) -> Bool {
        if passwd != repasswd { return false }
        return true
    }
    
    func checkSpecialCharacter(userName: String) -> String? {
        if CheckSpecialCharacter.share.checkCharacterIsNumber(string: userName) {
            return "Tên đăng nhập không được sử dụng kí tự đặc biệt"
        }
        return nil
    }
    
    func checkImage(img: UpdateUI) -> Bool {
        if img.setUIImage() == nil { return false }
        return true
    }
    
    func checkFullInfo(userName: String, passWd: String, repasswd: String, img: UpdateUI) -> String? {
        if userName == "" || passWd == "" {
            return "Vui lòng điền đầy đủ thông tin"
        }
        if !checkRepasswd(passwd: passWd, repasswd: repasswd) {
            return "Nhập lại mật khẩu không chính xác"
        }
        if !checkImage(img: img) {
            return "Vui lòng chọn ảnh đại diện"
        }
        return checkSpecialCharacter(userName: userName)
    }
    
    func navigationPushHomeShop(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(TabBarHomeShop.self)
        view.pushVC(view: viewControllerMain)
    }
    
    func navigationPushHomeShipper(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(HomeShipper.self)
        view.pushVC(view: viewControllerMain)
    }
    
    func makeParameter(username: String, passwd: String, image: UIImage?,firstAndLastName: String ,typeUser: String) -> [String: Any] {
        var dic : [String: Any] = [:]
        dic["phonenumber"] = username
        dic["passwd"]   = passwd
        dic["name"] = image
        dic["nameType"] = typeUser
        dic["nameUser"] = firstAndLastName
        return dic
    }

    func sign(image: UIImage?, userName: String, passWd: String,firstAndLastName: String ,typeUser: String,updateUIButton: UpdateUI, completion: @escaping (LoginResultHaveData)->()) {
        let dictionary = makeParameter(username: userName, passwd: passWd, image: image, firstAndLastName: firstAndLastName, typeUser: typeUser)
         updateUIButton.disableUIButton()
        news.loadData(urlString: API.signUp, method: HTTPMethod.post, dic: dictionary, fileName: userName, typeImage: "png", completion: {
            (object) in
            let errOr = object as? String ?? ""
            if errOr == "tam khac 0" {
                updateUIButton.enabledButton()
                completion(LoginResultHaveData.error(message: "Tài khoản này đã tồn tại"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResultHaveData.success(data: user))
            }
        })
    }
    
    func clickSign(image: UpdateUI, userName: String, passWd: String, repasswd: String, firstAndLastName: String, typeUser: String, view: PushPopNavigation, updateLable: UpdateUI, updateUIButton: UpdateUI) {
        let errorMes = checkFullInfo(userName: userName, passWd: passWd, repasswd: repasswd, img: image)
        
        guard errorMes == nil else {
            updateLable.updateUILableError(lable: errorMes ?? "")
            return
        }
        guard let img = image.setUIImage() else { return }
        
        sign(image: img , userName: userName, passWd: passWd, firstAndLastName: firstAndLastName, typeUser: typeUser, updateUIButton: updateUIButton) { (result) in
            switch result {
            case .error(let message):
                updateLable.updateUILableError(lable: message)
            case .success(let data):
                updateUIButton.disableUIButton()
                if data.nameType == TypeUser.Shop.rawValue {
             	     UserDefaults.standard.set(true, forKey: KeyUserDefault.typeAccount.rawValue)
                     self.navigationPushHomeShop(data: data, view: view)
                }
                if data.nameType == TypeUser.Shipper.rawValue {
                    UserDefaults.standard.set(false, forKey: KeyUserDefault.typeAccount.rawValue)
                    self.navigationPushHomeShipper(data: data, view: view)
                }
            }
        }
    }
}


