//
//  ViewController.swift
//  GET-POST
//
//  Created by datnguyen on 10/3/16.
//  Copyright © 2016 datnguyen. All rights reserved.
//

import UIKit

enum API:String{
    case listSP = "GETSP.php"
    case postImage = "postText.php"
    var fullLink:String{
        return "https://swift-developers.com/" + self.rawValue
    }
}

enum HTTPMethod:String{
    case post = "POST"
    case get = "GET"
    var method:String{
        return self.rawValue
    }
}


class ViewController: UIViewController {
    
    @IBAction func Upload(_ sender: AnyObject) {
        loadData(urlString: API.postImage, method: HTTPMethod.post, dic: ["name": "dat"], completion: {
            (object) in
            print(object)
        })
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func loadData(urlString:API,method:HTTPMethod?,dic:Dictionary<String,Any>?,completion:@escaping (Any)->()){
        var str:String = ""
        var param:String = ""
        if dic != nil{
            param = (dic!.convertDictoString())
        }
        if method == nil || method == HTTPMethod.get{
            str = urlString.fullLink + "?" + param
        }else{
            str = urlString.fullLink
        }
        let url:URL = URL(string: str)!
        var request:URLRequest = URLRequest(url: url)
        if method == HTTPMethod.post{
            request.httpMethod = method?.method
            let body:NSMutableData = NSMutableData()
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            for i in dic!{
                if let image = i.value as? UIImage{
                    let dataimg = UIImageJPEGRepresentation(image, 0.5)
                    let fname = "datnguyen.jpeg"
                    let mimetype = "image/png"
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(i.key)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(dataimg!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                }else{
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(i.key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(i.value)\r\n".data(using: String.Encoding.utf8)!)
                }
            }
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            request.httpBody = body as Data
        }
        let session:URLSession = URLSession.shared
        session.dataTask(with: request, completionHandler: {
            (data,res,err) in
            print(String(data: data!, encoding: .utf8))
            do{
                let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                DispatchQueue.main.async {
                    completion(result)
                }
            }catch{}
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Dictionary{
    //["index":0,"number":1] -> "index=0&number=1"
    func convertDictoString() -> String {
        var str = ""
        for (index,i) in self.enumerated(){
            if index == 0{
                str = str + "\(i.key)=\(i.value)"
            }else{
                str = str + "&\(i.key)=\(i.value)"
            }
        }
        return str
    }
}
