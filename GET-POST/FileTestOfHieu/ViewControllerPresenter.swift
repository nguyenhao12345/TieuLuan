//
//  ViewControllerPresenter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/20/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
protocol ViewControllerPresenter {
    func actionCamera(view: UIViewController,imagePickerController: UIImagePickerController )
}
class ViewControllerPresenterImp: ViewControllerPresenter {
    func actionCamera(view: UIViewController, imagePickerController: UIImagePickerController ) {
       
        imagePickerController.delegate = view as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let actionSheet = UIAlertController(title: "photo source", message: "choose a source", preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            view.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "photo Library", style: .default, handler: { (action:UIAlertAction) in
            view.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view.present(actionSheet, animated: true, completion: nil)
    }
    
 
    
    
}
