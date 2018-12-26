//
//  Home.swift
//  Shop
//
//  Created by Nguyen Hieu on 11/27/18.
//  Copyright © 2018 com.nguyenhieu.tieuluan. All rights reserved.
//

import UIKit

class Home: UIViewController {

    @IBOutlet private weak var imageHinh: UIImageView!
    func config(url: String) {
        LoadImageFromService.share.loadPhotoFromService(url) { [weak self] (imageToCache) in
            if let strongSelf = self {
                strongSelf.imageHinh.image = imageToCache
            }
            else {
                print("k load dc")
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    



}
