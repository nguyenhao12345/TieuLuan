//
//  New.swift
//  GET-POST
//
//  Created by HaoNguyen on 10/31/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class NewViewController: ViewController {
    @IBOutlet weak private var communicationTableView: UITableView!
    fileprivate var presenter: NewViewControllerPresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        presenter = NewViewControllerPresenterImp()
        presenter?.register(nibName: "CommunicationTableViewCell", forCellWithReuseIdentifier: "communicationTableViewCell", tableView: communicationTableView)
    }
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

extension NewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.heightForRowAt() ?? 0
    }
}
