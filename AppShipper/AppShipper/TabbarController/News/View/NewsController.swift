//
//  NewsController.swift
//  AppShipper
//
//  Created by HaoNguyen on 11/27/18.
//  Copyright © 2018 HaoNguyen. All rights reserved.
//

import UIKit

protocol ChangeUIViewController {
    func reload()
    func push(to view: UIViewController)
}

protocol ViewControllerTabar {
    var imageBar: String { get }
    var titleBar: String { get }
}

class NewsController: UIViewController, ViewControllerTabar {
    @IBOutlet weak private var tableViewNews: UITableView!
    private var presenter: NewsControllerPresenter?
    
    var imageBar: String {
        return "news"
    }
    
    var titleBar: String {
        return "News"
    }
    
    func inject(presenterNewsController: NewsControllerPresenter) {
        presenter = presenterNewsController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
          presenter?.getData(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.image = UIImage(named: "news")
        presenter?.getData(view: self)
        presenter?.register(tableView: tableViewNews)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}

extension NewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.heightForRowAt() ?? 0
    }
}

extension NewsController: UITableViewDataSource {
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

extension NewsController: ChangeUIViewController {
    func push(to view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
    
    func reload() {
        tableViewNews.reloadData()
    }
}
