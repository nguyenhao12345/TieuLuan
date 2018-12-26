//
//  Sign.swift
//  Shop
//
//  Created by Nguyen Hieu on 11/23/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class Sign: UIViewController {
    
    @IBOutlet weak var chooseImageFromCameraOrLib: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var identificationCardTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    private var presenterSign: SignPresenter?

    
    func inject(presenter: SignPresenter) {
        presenterSign = presenter
    }
    
    @IBAction func clickChooseImage(_ sender: Any) {
        presenterSign?.clickCamera(view: self)
    }
    @IBAction func clickSign(_ sender: Any) {
        presenterSign?.registAccount(email: emailTextField.text ?? "", pass: passwdTextField.text ?? "",fullname: fullNameTextField.text ?? "" , phonenumber: phoneNumberTextField.text ?? "" , typeAccount: 1 , identifi: identificationCardTextField.text ?? "", image: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
}
protocol PushPopNavigation {
    func pushVC(view: UIViewController)
    func present(view: UIViewController)
    func popVC(view: UIViewController)
}
extension Sign: PushPopNavigation {
    func popVC(view: UIViewController) {
        guard let navigationController = navigationController else {
            present(view, animated: true, completion: nil)
            return
        }
        navigationController.popToViewController(view, animated: true)
    }
    func pushVC(view: UIViewController) {
        guard let navigationController = navigationController else {
            present(view, animated: true, completion: nil)
            return
        }
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(view, animated: true)
    }
    func present(view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
}

protocol UpdateUI {
    func updataUIImagePicker(image: UIImage)
}

extension Sign: UpdateUI {
    func updataUIImagePicker(image: UIImage) {
        self.imgUser.image = image
    }
}
protocol GetDataFormUIPicker {
    func getImageFromUIPicker() -> UIImage?
}
extension Sign: GetDataFormUIPicker {
    func getImageFromUIPicker() -> UIImage? {
        return imgUser.image
    }
}

extension Sign: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenterSign?.didFinishPickingMediaWithInfo(picker: picker, didFinishPickingMediaWithInfo: info, updataUIImage: self)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenterSign?.imagePickerControllerDidCancel(picker)
    }
}

extension Sign {
    static func create() -> Sign {
        let viewControllerSign = instantiate(Sign.self)
        viewControllerSign.inject(presenter: SignPresenterImp())
        
        return viewControllerSign
    }
}
