//
//  ListNewsController.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/3/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class ListNewsController: UIViewController, ViewControllerTabar {
    var nameBar: String {
        return "Lưu trữ"
    }
    var index: Int {
        return 1
    }
    var image: UIImage {
        return UIImage.init(named: "luu tru") ?? UIImage()
    }

    @IBOutlet weak var tableViewSaveOfShop: UITableView!
    
    private var presenterListNews: ListNewsPresenter?
    func inject(presenter: ListNewsPresenter) {
        self.presenterListNews = presenter
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "CellListNews", bundle: nil)
         tableViewSaveOfShop.register(nib, forCellReuseIdentifier: "CellListNews")
        
        tableViewSaveOfShop.dataSource = self
//        tableViewSaveOfShop.delegate = self
        tableViewSaveOfShop.estimatedRowHeight = 800
        tableViewSaveOfShop.rowHeight = UITableView.automaticDimension
        
        presenterListNews?.paserDataFromFirebase(tableView: tableViewSaveOfShop)
        
    }
    
}
//extension ListNewsController: UITableViewDelegate
extension ListNewsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenterListNews?.count() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return presenterListNews?.cellForRowAt(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }

}

