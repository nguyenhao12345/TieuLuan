//
//  DetailCreateNews.swift
//  Shop
//
//  Created by Nguyen Hieu on 12/2/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import UIKit

class DetailCreateNews: UIViewController {
    private var presenterDetailCreateNews: DetailCreateNewsPresenter?
    
    func inject(presenter: DetailCreateNewsPresenter) {
        self.presenterDetailCreateNews = presenter
    }
    
    @IBAction func clickPostItem(_ sender: Any) {
        presenterDetailCreateNews?.clickPostItem(title: titleTextField.text ?? "" , content: contentTextField.text ?? "" , mass: Double(massTextField.text ?? "0") ?? 0  , price: Double(priceTextField.text ?? "0") ?? 0 , avance: Double(avanceTextField.text ?? "0") ?? 0, phoneNumberCustomer: phoneCustomerTextField.text ?? "", nameCustomer: nameCustomerTextField.text ?? "", image: self, view: self, button: postItemButton)
    }
    @IBAction func clickChooseImage(_ sender: Any) {
        presenterDetailCreateNews?.clickCamera(view: self)
    }
    private let picker = UIPickerView()
    fileprivate var dataTypeItem: [TypeItem] = [TypeItem.ShipInDay,TypeItem.FastShip, TypeItem.deFault1,TypeItem.deFault2 ]
    
    private func createPickerView() {
        picker.delegate = self
        picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        titleTextField.inputView = picker
        picker.backgroundColor = UIColor.gray
    }
    
    @IBOutlet weak var postItemButton: UIButton!
    @IBOutlet weak var nameCustomerTextField: UITextField!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var phoneCustomerTextField: UITextField!
    @IBOutlet weak var avanceTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var massTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterDetailCreateNews?.test()
        createPickerView()
    }

}
extension DetailCreateNews: MoveStoryboard {
    func push(view: UIViewController) {
        
    }
    
    func pop() {
        self.postItemButton.isEnabled = true
        self.navigationController?.popViewController(animated: true)
    }

    func present(view: UIViewController) {
        self.present(view, animated: false, completion: nil)
    }
    
}
//extension DetailCreateNews: PushPopNavigation {
//    func pushVC(view: UIViewController) {
//
//    }
//
//    func present(view: UIViewController) {
//        self.present(view, animated: false, completion: nil)
//    }
//
//    func popVC(view: UIViewController) {
//
//    }
//
//
//}
extension DetailCreateNews: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenterDetailCreateNews?.didFinishPickingMediaWithInfo(picker: picker, didFinishPickingMediaWithInfo: info, updataUIImage: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenterDetailCreateNews?.imagePickerControllerDidCancel(picker)
    }
}
extension DetailCreateNews: UpdateUI {
    func updataUIImagePicker(image: UIImage) {
        self.imgItem.image = image
    }
}
extension DetailCreateNews: GetDataFormUIPicker {
    func getImageFromUIPicker() -> UIImage? {
        return imgItem.image
    }
}

extension DetailCreateNews : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataTypeItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataTypeItem[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleTextField.text =  dataTypeItem[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}

extension DetailCreateNews : UIPickerViewDelegate {}

enum TypeItem: String {
    case ShipInDay    = "Ship trong ngày"
    case FastShip = "Ship ngay"
    case deFault1 = "Hàng nặng - cồng kềnh cần ship trong ngày"
    case deFault2 = "Ship bình thường"
    var result: String {
        return self.rawValue
    }
}
extension DetailCreateNews: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
