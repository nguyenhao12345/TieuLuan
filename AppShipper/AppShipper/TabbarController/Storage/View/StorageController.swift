//
//  StorageController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/27/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

class StorageController: UIViewController, ViewControllerTabar {
    var titleBar: String {
        return "Storage"
    }
    
    var imageBar: String {
        return "storage"
    }
    
    @IBOutlet weak private var tableViewStorage: UITableView!
    private var presenter: StorageControllerPresenter?
    
    func inject(storageControllerPresenter: StorageControllerPresenter) {
        presenter = storageControllerPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.register(tableView: tableViewStorage)
        presenter?.getData(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}

extension StorageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.heightForRowAt() ?? 0
    }
}

extension StorageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(didSelectRowAt: indexPath, view: self)
    }
}

extension StorageController: ChangeUIViewController {
    func reload() {
        tableViewStorage.reloadData()
    }
    
    func push(to view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
}
