//
//  DetailNewsController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/29/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

protocol ChangeUIDetailNewController {
    func setUpLabelTime(time: String)
    func setUpLabelFullName(fullName: String)
    func setUpLabelPhoneNumber(phoneNumber: String)
    func setUpLabelNameStartPoint(nameStartPoint: String)
    func setUpLabelNameFinishPoint(nameFinishPoint: String)
    func setUpLabelNameTitle(nameTitle: String)
    func setUpLabelMass(mass: String)
    func setUpLabelDescription(description: String)
    func setUpLabelAdvance(advance: String)
    func setUplabelMoneyGet(moneyGet: String)
    func setUpImageProduct(image: UIImage)
    func popToNewsViewController()
}

class DetailNewController: UIViewController {
    @IBOutlet weak fileprivate var labelTime: UILabel!
    @IBOutlet weak fileprivate var labelFullName: UILabel!
    @IBOutlet weak fileprivate var labelPhoneNumber: UILabel!
    @IBOutlet weak fileprivate var labelNameStartPoint: UILabel!
    @IBOutlet weak fileprivate var labelNameFinishPoint: UILabel!
    @IBOutlet weak fileprivate var labelNameTitle: UILabel!
    @IBOutlet weak fileprivate var labelMass: UILabel!
    @IBOutlet weak fileprivate var labelDescription: UILabel!
    @IBOutlet weak fileprivate var labelAdvance: UILabel!
    @IBOutlet weak fileprivate var labelMoneyGet: UILabel!
    @IBOutlet weak fileprivate var imageProduct: UIImageView!
    private var presenterNewsController: PresenterDetailNewController?
    
    @IBAction func getNew(_ sender: Any) {
        presenterNewsController?.getNew(view: self)
    }
    
    func inject(presenterNewsController: PresenterDetailNewController) {
        self.presenterNewsController = presenterNewsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail New"
        presenterNewsController?.changUIView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

extension DetailNewController: ChangeUIDetailNewController {
    func setUpLabelAdvance(advance: String) {
        labelAdvance.text = advance
    }
    
    func setUplabelMoneyGet(moneyGet: String) {
        labelMoneyGet.text = moneyGet
    }
    
    func setUpLabelTime(time: String) {
        labelTime.text = time
    }
    
    func setUpLabelFullName(fullName: String) {
        labelFullName.text = fullName
    }
    
    func setUpLabelPhoneNumber(phoneNumber: String) {
        labelPhoneNumber.text = phoneNumber
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
    
    func setUpImageProduct(image: UIImage) {
        imageProduct.image = image
    }
    
    func popToNewsViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
