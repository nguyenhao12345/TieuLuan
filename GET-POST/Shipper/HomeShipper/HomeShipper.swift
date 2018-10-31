//
//  HomeShipper.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/27/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

class HomeShipper: UIViewController {

    @IBAction func clickLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "typeAccount")
        let vc = UIStoryboard(name: "Login1", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login1")
        let navVC = UINavigationController(rootViewController: vc)
        let share = UIApplication.shared.delegate as? AppDelegate
        share?.window?.rootViewController = navVC
        share?.window?.makeKeyAndVisible()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;
        navigationController?.isNavigationBarHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
