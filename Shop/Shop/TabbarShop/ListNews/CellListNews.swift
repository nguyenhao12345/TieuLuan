//
//  CellListNews.swift
//  Shop
//
//  Created by Nguyen Hieu on 12/9/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import UIKit

class CellListNews: UITableViewCell {

    @IBOutlet weak var timeProduct: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var viewPoint: UIView!
   
    @IBOutlet weak var startPoint: UILabel!
    
    @IBOutlet weak var finishPoint: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var nameCustomer: UILabel!
    @IBOutlet weak var avance: UILabel!
    @IBOutlet weak var phoneCustomer: UILabel!
    
    @IBOutlet weak var phoneShip: UILabel!
    @IBOutlet weak var nameShip: UILabel!
    
    
    func configDataForCell(startPoint: String,
                           finishPoint: String,
                           price: Double,
                           avance: Double,
                           nameCustomer: String,
                           phoneCustomer: String,
                           nameShip: String,
                           phoneShip: String,
                           urlImage: String,
                           status: String,
                           timeProduct: String) {
        self.startPoint.text = startPoint
        self.finishPoint.text = finishPoint
        self.price.text = String(price)
        self.avance.text = String(avance)
        self.nameCustomer.text = nameCustomer
        self.phoneCustomer.text = phoneCustomer
        self.nameShip.text = nameShip
        self.phoneShip.text = phoneShip
        
        //urlImage:   url m truyền vào
        //img : UImage m nhận
        LoadImageFromService.share.loadPhotoFromService(urlImage) { (img) in
            self.imageItem.image = img
        }
        
        
//        UIImage.loadPhotoFromService(url: urlImage, completion: { (img) in
//            self.imageItem.image = img
//        })
        self.status.text = status
        self.timeProduct.text = timeProduct
    }

}
