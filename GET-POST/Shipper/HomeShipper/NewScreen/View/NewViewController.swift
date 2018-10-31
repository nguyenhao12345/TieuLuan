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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        let communicationNib = UINib(nibName: "CommunicationTableViewCell", bundle: nil)
        communicationTableView.register(communicationNib, forCellReuseIdentifier: "communicationTableViewCell")
    }
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let communicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "communicationTableViewCell", for: indexPath) as? CommunicationTableViewCell else { return UITableViewCell()}
        return communicationTableViewCell
    }
}

extension NewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
