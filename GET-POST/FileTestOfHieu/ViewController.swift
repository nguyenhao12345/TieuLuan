//
//  ViewController.swift
//  GET-POST
//
//  Created by datnguyen on 10/3/16.
//  Copyright © 2016 datnguyen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBAction func actionCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "photo source", message: "choose a source", preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var imageHinh: UIImageView!
    @IBOutlet weak private var input: UITextField!
    @IBOutlet weak private var lbl: UILabel!
    private let news = Service()
    
    @IBAction func Upload(_ sender: AnyObject) {
        let name = input.text!
        news.loadData(urlString: API.upimage, method: HTTPMethod.post, dic: ["name": imageHinh.image,"uphinh": name], fileName: "andlawdaw", typeImage: "png", completion: {
            (object) in
            print(object)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageHinh.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ViewController: UINavigationControllerDelegate {
}
