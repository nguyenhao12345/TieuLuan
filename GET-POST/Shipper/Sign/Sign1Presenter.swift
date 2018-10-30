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
    func clickSign(image: UpdateUI, userName: String, passWd: String,repasswd: String,firstAndLastName: String ,typeUser: String, view: PushPopNavigation, updateLable: UpdateUI,updateUIButton: UpdateUI)
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any], updataUIImage: UpdateUI)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    func clickCamera(view: PushPopNavigation)
    func clickBack(view: PushPopNavigation)
}
class Sign1PresenterImp: Sign1Presenter {
    func clickBack(view: PushPopNavigation) {
        let viewControllerMain = instantiate(Login1.self, storyboard: "Login1")
        view.popVC(view: viewControllerMain)
    }
    
    func clickCamera(view: PushPopNavigation) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = view as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let actionSheet = UIAlertController(title: "Photos", message: "Choose a Source", preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            view.present(view: imagePickerController)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            view.present(view: imagePickerController)
//            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view.present(view: actionSheet)
//        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didFinishPickingMediaWithInfo(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], updataUIImage: UpdateUI) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        updataUIImage.updataUIImagePicker(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    private let news = Service()
    func checkRepasswd(passwd: String, repasswd: String) -> Bool {
        if passwd != repasswd {
            return false
        }
        return true
    }
    func checkSpecialCharacter(userName: String) -> String? {
        if CheckSpecialCharacter.share.checkCharacterIsNumber(string: userName) {
            return "Tên đăng nhập không được sử dụng kí tự đặc biệt"
        }
        return nil
    }
    func checkImage(img: UpdateUI) -> Bool {
        if img.setUIImage() == nil {
            return false
        }
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
        let viewControllerMain = instantiate(HomeShop.self, storyboard: "HomeShop")
        viewControllerMain.config(name: data.nameUser, img: data.image, phone: data.phonenumber, pass: data.pass)
        view.pushVC(view: viewControllerMain)
    }
    func navigationPushHomeShipper(data: DataUser, view: PushPopNavigation) {
        let viewControllerMain = instantiate(HomeShipper.self, storyboard: "HomeShipper")
//        viewControllerMain.config(name: data.nameUser, img: data.image)
        view.pushVC(view: viewControllerMain)
    }
    func makeParameter(username: String, passwd: String, image: UIImage?,firstAndLastName: String ,typeUser: String) -> [String: Any] {
        var dic : [String: Any]   =  ["phonenumber": "", "passwd": "", "name": "", "nameType":"","nameUser":""]
        dic["phonenumber"] = username
        dic["passwd"]   = passwd
        dic["name"] = image
        dic["nameType"] = typeUser
        dic["nameUser"] = firstAndLastName
        return dic
    }
    enum LoginResult {
        case error(message: String)
        case success(data: DataUser)
    }
    
    func sign(image: UIImage?, userName: String, passWd: String,firstAndLastName: String ,typeUser: String,updateUIButton: UpdateUI, completion: @escaping (LoginResult)->()) {
        let dictionary = makeParameter(username: userName, passwd: passWd, image: image, firstAndLastName: firstAndLastName, typeUser: typeUser)
         updateUIButton.updataUIButton()
        news.loadData(urlString: API.signUp, method: HTTPMethod.post, dic: dictionary, fileName: userName, typeImage: "png", completion: {
            (object) in
            let errOr = object as? String ?? ""
            if errOr == "tam khac 0" {
                updateUIButton.enabledButton()
                completion(LoginResult.error(message: "Tài khoản này đã tồn tại"))
            }
            else {
                guard let dataNews = object as? [String: String] else { return }
                let user = DataUser(data: dataNews)
                completion(LoginResult.success(data: user))
            }
        })
    }
    
    func clickSign(image: UpdateUI, userName: String, passWd: String,repasswd: String, firstAndLastName: String ,typeUser: String, view: PushPopNavigation, updateLable: UpdateUI, updateUIButton: UpdateUI) {
        let errorMes = checkFullInfo(userName: userName, passWd: passWd, repasswd: repasswd, img: image)
        guard errorMes == nil else {
            updateLable.updateUILableError(lable: errorMes ?? "")
            return
        }
        guard let img = image.setUIImage() else {
            return
        }
        sign(image: img , userName: userName, passWd: passWd, firstAndLastName: firstAndLastName, typeUser: typeUser, updateUIButton: updateUIButton) { (result) in
            switch result {
            case .error(let message):
                updateLable.updateUILableError(lable: message)
            case .success(let data):
                updateUIButton.updataUIButton()
                if data.nameType == "Shop" {
                    UserDefaults.standard.set(userName, forKey: "phoneNumber")
                     self.navigationPushHomeShop(data: data, view: view)
                }
                if data.nameType == "Shipper" {
                    self.navigationPushHomeShipper(data: data, view: view)
                }
            }
        }
    }
}

class CheckSpecialCharacter {
    static let share = CheckSpecialCharacter()
    func checkCharacter(string: String) -> Bool {
        for character in string.utf8 {
            if character < 48 || (character > 57 && character < 65) || (character > 90 && character < 97) || character > 122  {
                return true
            }
        }
        return false
    }
    func checkCharacterIsNumber(string: String) -> Bool {
        for character in string.utf8 {
            if character > 47 && character < 58  {
                return false
            }
        }
        return true
    }
}
