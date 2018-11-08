//
//  HomeShopPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/27/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol HomeShopPresenter {
  func getData(lblName: UpdateUIHomeShop,image: UpdateUIHomeShop,view3_Name: UpdateUIHomeShop,view3_Pass: UpdateUIHomeShop ,view3_Phone: UpdateUIHomeShop,view3_Image: UpdateUIHomeShop)
    func clickLoutout(view: PushPopNavigation)
    func clickPostItem(startPoint: String , lastPoint: String, price: String , content: String, phonenumber: String, mesError: UpdateUI, view: PushPopNavigation, constrain: UpdateUIHomeShop, updateUIAfterSuccess: UpdateUIHomeShop)
}

class HomeShopPresenterImp: HomeShopPresenter {
    private let postData = Service()
    func clickLoutout(view: PushPopNavigation) {
        
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        view.present(view: alert)
    
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel,handler:{ (action:UIAlertAction) in
        }))
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            UserDefaults.standard.removeObject(forKey: "phoneNumber")
            UserDefaults.standard.removeObject(forKey: "typeAccount")
            let vc = UIStoryboard(name: "Login1", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login1")
            let navVC = UINavigationController(rootViewController: vc)
            let share = UIApplication.shared.delegate as? AppDelegate
            share?.window?.rootViewController = navVC
            share?.window?.makeKeyAndVisible()
        }))
    }
    //đăng bài
    func clickPostItem(startPoint: String, lastPoint: String, price: String, content: String, phonenumber: String,mesError: UpdateUI, view: PushPopNavigation,constrain: UpdateUIHomeShop, updateUIAfterSuccess: UpdateUIHomeShop) {
        let errMess = checkFullInfo(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content)
        if errMess == nil {
            postItem(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content, phonenumber: phonenumber) { (result) in
                switch result {
                case .error(let message):
                    let alert = UIAlertController(title: "Thất bại", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    view.present(view: alert)
                case .success(let message):
                    constrain.updataConstrain(numberConstrain: 997)
                    let alert = UIAlertController(title: "Thành công", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    view.present(view: alert)
                    updateUIAfterSuccess.updateUIAfterPostItemSucess()
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Thất bại", message: errMess, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            view.present(view: alert)
        }
    }
    
    func postItem(startPoint: String, lastPoint: String, price: String, content: String, phonenumber: String, completion: @escaping (LoginResult) -> ()) {
         let dictionary = makeParameter(startPoint: startPoint, lastPoint: lastPoint, price: price, content: content, phonenumber: phonenumber)
        postData.loadData(urlString: API.postItemOfShop, method: HTTPMethod.post, dic: dictionary) { (object) in
            let errOr = object as? String ?? ""
            if errOr == "k ket noi dc" {
                completion(LoginResult.error(message: "Vui lòng xem lại kết nối mạng"))
            }
            if errOr == "thanh cong"  {
                completion(LoginResult.success(data: "Bài viết của bạn đã được đăng vào news của Shipper"))
                
            }
        }
    }
    func makeParameter(startPoint: String, lastPoint: String, price: String, content: String ,phonenumber: String) -> [String: String] {
        var dic : [String: String]   =  ["startPoint": "", "lastPoint": "", "price": "", "content":"","phonenumber":""]
        dic["startPoint"] = startPoint
        dic["lastPoint"]   = lastPoint
        dic["price"] = price
        dic["content"] = content
        dic["phonenumber"] = phonenumber
        return dic
    }
    
    func checkFullInfo(startPoint: String, lastPoint: String, price: String, content: String) -> String? {
        if startPoint == "" || lastPoint == "" || price == "" || content == "" {
            return "Vui lòng điền đầy đủ thông tin"
        }
        return nil
    }
    
    
    
    func getData(lblName: UpdateUIHomeShop,image: UpdateUIHomeShop,view3_Name: UpdateUIHomeShop,view3_Pass: UpdateUIHomeShop ,view3_Phone: UpdateUIHomeShop,view3_Image: UpdateUIHomeShop) {
        postData.loadData(urlString: API.getDataLogined, method: HTTPMethod.post, dic: ["phonenumber": UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""]) { (result) in
            _ = result as? String ?? ""
            guard let dataNews = result as? [String: String] else { return }
            let user = DataUser(data: dataNews)

            lblName.updateUINameUser(name: user.nameUser)
            image.updateUIImageAvata(nameImg: user.image)
            
            view3_Name.updateUINameUser(name: user.nameUser)
            view3_Pass.updateUIPasswd(pass: user.pass)
            view3_Phone.updateUIPhone(phone: user.phonenumber)
            view3_Image.updateUIImageAvata(nameImg: user.image)
        }
    }
    
}
