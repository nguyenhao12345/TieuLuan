//
//  Service.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/20/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
import UIKit

class Service {
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func loadData(urlString: API, method: HTTPMethod = .get, dic: Dictionary<String,Any>?, fileName: String = "default", typeImage: String = "default", completion: @escaping (Any)->()) {
        var str: String = ""
        var param: String = ""
        if dic != nil {
            param = (dic!.convertDictoString())
        }
        if method == nil || method == HTTPMethod.get {
            str = urlString.fullLink + "?" + param
        }
        else {
            str = urlString.fullLink
        }
        let url:URL = URL(string: str)!
        var request:URLRequest = URLRequest(url: url)
        if method == HTTPMethod.post {
            request.httpMethod = method.method
            let body:NSMutableData = NSMutableData()
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            for i in dic! {
                if let image = i.value as? UIImage {
                    let dataimg = UIImageJPEGRepresentation(image, 0.2)
                    let fname = fileName + "." + typeImage
                    let mimetype = "image/png"
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(i.key)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(dataimg!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                }
                else {
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(i.key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(i.value)\r\n".data(using: String.Encoding.utf8)!)
                }
            }
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            request.httpBody = body as Data
        }
        let session: URLSession = URLSession.shared
        session.dataTask(with: request, completionHandler: {
            (data,res,err) in
            //print(String(data: data!, encoding: .utf8))
            guard let dataExport = data else { print("k co mang")
                return }
            do{
                let result = try JSONSerialization.jsonObject(with: dataExport, options: JSONSerialization.ReadingOptions.allowFragments)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            catch{
                print("ngoai le")
            }
        }).resume()
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
