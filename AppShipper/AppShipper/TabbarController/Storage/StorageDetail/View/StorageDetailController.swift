//
//  StorageDetail.swift
//  AppShipper
//
//  Created by HaoNguyen on 12/2/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

protocol ChangeUIStorageDetailController {
    func setUpLabelTime(time: String)
    func setUpLabelFullNameShop(fullName: String)
    func setUpLabelPhoneNumberShop(phoneNumber: String)
    func setUpLabelCardIdShop(cardId: String)
    func setUpLabelFullNameReceiver(fullName: String)
    func setUpLabelPhoneNumberReceiver(phoneNumber: String)
    func setUpLabelNameStartPoint(nameStartPoint: String)
    func setUpLabelNameFinishPoint(nameFinishPoint: String)
    func setUpLabelNameTitle(nameTitle: String)
    func setUpLabelMass(mass: String)
    func setUpLabelDescription(description: String)
    func setUpLabelAdvance(advance: String)
    func setUplabelMoneyGet(moneyGet: String)
    func setUpImageProduct(image: UIImage)
    func popToStorageController()
}

class StorageDetailController: UIViewController {
    @IBOutlet weak fileprivate var labelTime: UILabel!
    @IBOutlet weak fileprivate var labelFullNameShop: UILabel!
    @IBOutlet weak fileprivate var labelPhoneNumberShop: UILabel!
    @IBOutlet weak fileprivate var labelCardIdShop: UILabel!
    @IBOutlet weak fileprivate var labelFullNameReceiver: UILabel!
    @IBOutlet weak fileprivate var labelPhoneNumberReceiver: UILabel!
    @IBOutlet weak fileprivate var labelCardIdReceiver: UILabel!
    @IBOutlet weak fileprivate var labelNameStartPoint: UILabel!
    @IBOutlet weak fileprivate var labelNameFinishPoint: UILabel!
    @IBOutlet weak fileprivate var labelNameTitle: UILabel!
    @IBOutlet weak fileprivate var labelMass: UILabel!
    @IBOutlet weak fileprivate var labelDescription: UILabel!
    @IBOutlet weak fileprivate var labelAdvance: UILabel!
    @IBOutlet weak fileprivate var labelMoneyGet: UILabel!
    @IBOutlet weak fileprivate var imageProduct: UIImageView!
    
    private var presenter: StorageDetailControllerPresenter?
    
    func inject(storageDetailControllerPresenter: StorageDetailControllerPresenter) {
        presenter = storageDetailControllerPresenter
    }
    
    
    @IBAction func deleteProduct(_ sender: Any) {
        presenter?.deleteProduct(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail Storage"
        presenter?.changUIView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

extension StorageDetailController: ChangeUIStorageDetailController {
    func setUpLabelTime(time: String) {
        labelTime.text = time
    }
    
    func setUpLabelFullNameShop(fullName: String) {
        labelFullNameShop.text = fullName
    }
    
    func setUpLabelPhoneNumberShop(phoneNumber: String) {
        labelPhoneNumberShop.text = phoneNumber
    }
    
    func setUpLabelCardIdShop(cardId: String) {
        labelCardIdShop.text = cardId
    }
    
    func setUpLabelFullNameReceiver(fullName: String) {
        labelFullNameReceiver.text = fullName
    }
    
    func setUpLabelPhoneNumberReceiver(phoneNumber: String) {
        labelPhoneNumberReceiver.text = phoneNumber
    }
    
    func setUpLabelNameStartPoint(nameStartPoint: String) {
        labelNameStartPoint.text = nameStartPoint
    }
    
    func setUpLabelNameFinishPoint(nameFinishPoint: String) {
        labelNameFinishPoint.text = nameFinishPoint
    }
    
    func setUpLabelNameTitle(nameTitle: String) {
        labelNameTitle.text = nameTitle
    }
    
    func setUpLabelMass(mass: String) {
        labelMass.text = mass
    }
    
    func setUpLabelDescription(description: String) {
        labelDescription.text = description
    }
    
    func setUpLabelAdvance(advance: String) {
        labelAdvance.text = advance
    }
    
    func setUplabelMoneyGet(moneyGet: String) {
        labelMoneyGet.text = moneyGet
    }
    
    func setUpImageProduct(image: UIImage) {
        imageProduct.image = image
    }
    
    func popToStorageController() {
        self.navigationController?.popViewController(animated: true)
    }
}
