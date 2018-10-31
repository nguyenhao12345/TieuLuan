//
//  UseCase.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/22/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//
//import Foundation
//
//class UseCase {
//    private let news = Service()
//    func getData(dic: Dictionary<String,Any>?,fileName: String, typeImage: String, completion: @escaping (DataUser) -> ()) {
//        news.loadData(urlString: API.signUp, method: HTTPMethod.post, dic: dic, fileName: fileName, typeImage: typeImage) { (data) in
//            guard let dataNews = data as? [String: Any] else { return }
//            let user = DataUser(name: <#T##String#>, pass: <#T##String#>, image: <#T##String#>)
//            completion(dataNews)
//        }
//    }x
//}
struct DataUser {
    let phonenumber: String
    let pass: String
    let image: String
    let nameType: String
    let nameUser: String
    init(data: [String: String]) {
        self.phonenumber = data["phonenumber"] ?? ""
        self.pass = data["passwd"] ?? ""
        self.image = data["url_image"] ?? ""
        self.nameType = data["nameType"] ?? ""
        self.nameUser = data["nameUser"] ?? ""
    }
//    func getName() -> String {
//        return name
//    }
//    func getUrl() -> String {
//        return image
//    }
}

struct DataNew {
    let news:  [ContentNews]
    init(data: [String: Any]) {
        var arr = [ContentNews]()
        for i in data["news"] as? [[String: Any]] ?? [] {
            arr.append(DataNew.ContentNews.init(data: i as? [String: String] ?? [:]))
        }
        self.news = arr
    }
    struct ContentNews {
        let content: String
        let photoName: String
        //        var photo: UIImage
        
        init(data: [String: String]) {
            self.content = data["content"] ?? ""
            self.photoName   = data["photo"] ?? ""
            //            self.photo = UIImage()
        }
        
    }
}
