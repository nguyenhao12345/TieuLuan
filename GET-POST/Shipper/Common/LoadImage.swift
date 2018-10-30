//
//  LoadImage.swift
//  LoadHinhService
//
//  Created by Nguyen Hieu on 10/8/18.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit


class LoadImageFromService {
    static let share = LoadImageFromService()
    private let imagecache = NSCache<AnyObject, AnyObject>()
    private let defaultImage = UIImage(named: "url")
    
    func loadPhotoFromService(_ url: String, completion: @escaping (UIImage) -> ())  {
        if let imageFromCache = imagecache.object(forKey: url as AnyObject) as? UIImage {
            completion(imageFromCache)
            return
        }
        
        guard let link = URL.init(string: url) else {
            completion(defaultImage ?? UIImage())
            return
        }
        URLSession.shared.dataTask(with: link, completionHandler: { (data, res, err) in
            DispatchQueue.main.async {
                guard let data = data, let imageToCache = UIImage(data: data) else {
                    completion(self.defaultImage ?? UIImage())
                    return
                }
                self.imagecache.setObject(imageToCache, forKey: url as AnyObject)
                completion(imageToCache)
            }
        }).resume()
    }
}
