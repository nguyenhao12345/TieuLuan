//
//  Sign1.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/21/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class Sign1: UIViewController {
    
    @IBOutlet fileprivate weak var activitySign1:    UIActivityIndicatorView!
    @IBOutlet fileprivate weak var typeUser:         UITextField!
    @IBOutlet fileprivate weak var firstAndLastName: UITextField!
    @IBOutlet fileprivate weak var btnSign:          UIButton!
    @IBOutlet fileprivate weak var mesError:         UILabel!
    @IBOutlet fileprivate weak var username:         UITextField!           //phone
    @IBOutlet fileprivate weak var passwd:           UITextField!
    @IBOutlet fileprivate weak var repasswd:         UITextField!
    @IBOutlet fileprivate weak var image:            UIImageView!
    
    fileprivate var presenter: Sign1Presenter?
    
    @IBAction private func clickSign(_ sender: Any) {
        presenter?.clickSign(image: self, userName: username.text ?? "", passWd: passwd.text ?? "", repasswd: repasswd.text ?? "", firstAndLastName: firstAndLastName.text ?? "", typeUser: typeUser.text ?? "", view: self, updateLable: self, updateUIButton: self)
   
    }
    @IBAction private func clickCamera(_ sender: Any) {
        presenter?.clickCamera(view: self)
    }
    @IBAction private func clickBack(_ sender: Any) {
        if let composeViewController = self.navigationController?.viewControllers[0] {
            self.navigationController?.popToViewController(composeViewController, animated: true)
        }
    }
    private let picker = UIPickerView()
    fileprivate var dataTypeUser: [TypeUser] = [.Shop, .Shipper]

    private func createPickerView() {
        picker.delegate = self
        picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        typeUser.inputView = picker
        picker.backgroundColor = UIColor.green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Sign1PresenterImp()
        createPickerView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
extension Sign1: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        presenter?.didFinishPickingMediaWithInfo(picker: picker, didFinishPickingMediaWithInfo: info, updataUIImage: self)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter?.imagePickerControllerDidCancel(picker)
    }
}
extension Sign1: UINavigationControllerDelegate {}

extension Sign1: UpdateUI {
    func enabledButton() {
        btnSign.isEnabled = true
        activitySign1.stopAnimating()
    }
    
    func updataConstrain(numberConstrain: Int) {}
    
    func updataUIImagePicker(image: UIImage) {
        self.image.image = image
    }

    func disableUIButton() {
        activitySign1.startAnimating()
        btnSign.isEnabled = false
        btnSign.isHighlighted = true
        
        btnSign.flash()
        btnSign.pulsate()
    }
    func updateUILableError(lable: String)  {
        mesError.text = lable
    }
    func setUIImage() -> UIImage? {
        return image.image
    }
}
extension Sign1: PushPopNavigation {
    func popVC(view: UIViewController) {
        guard let navigationController = navigationController else {
            present(view, animated: true, completion: nil)
            return
        }
        navigationController.popToViewController(view, animated: true)
    }
    func pushVC(view: UIViewController) {
        activitySign1.stopAnimating()
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

extension Sign1: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension Sign1 : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataTypeUser.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataTypeUser[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeUser.text =  dataTypeUser[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}
extension Sign1 : UIPickerViewDelegate {}

