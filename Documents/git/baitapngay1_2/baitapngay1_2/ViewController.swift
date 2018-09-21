//
//  ViewController.swift
//  baitapngay1_2
//
//  Created by Nguyen Hieu on 09/08/2018.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var imagePlayer1: UIImageView!
    @IBOutlet weak var imagePlayer2: UIImageView!
    let khoLuuHinh = ["keo","bua","bao"]
    var point = 0
    var bangKQ1 = [String]()
    
    @IBOutlet weak var labelKetQua: UILabel!
    
    @IBAction func ClickPlayer1(_ sender: Any) {
                let numberHinh:Int = Int(arc4random_uniform(3))
                let tenhinh = khoLuuHinh[numberHinh]
                imagePlayer1.image = UIImage.init(named: tenhinh)
        bangKQ1.append(tenhinh)
        if bangKQ1.count == 2 {
            if bangKQ1[0] == "keo"{
                if bangKQ1[1] == "keo"{
                    point = point + 0
                    print("hoa")
                }
                else if bangKQ1[1] == "bua"{
                    point = point + 10
                    print("sau thang")
                }
                else if bangKQ1[1] == "bao"{
                    point = point - 10
                    print("truoc thang")
                }
                bangKQ1.removeFirst()
            }
            else if bangKQ1[0] == "bua"{
                if bangKQ1[1] == "bua"{
                    point = point + 0
                    print("hoa")
                }
                else if bangKQ1[1] == "bao"{
                    point = point + 10
                    print("sau thang")
                }
                else if bangKQ1[1] == "keo"{
                    point = point - 10
                    print("truoc thang")
                }
                   bangKQ1.removeFirst()
            }
            else if bangKQ1[0] == "bao"{
                if bangKQ1[1] == "bao"{
                    point = point + 0
                    print("hoa")
                }
                else if bangKQ1[1] == "bua"{
                    point = point - 10
                    print("truoc thang")
                }
                else if bangKQ1[1] == "keo"{
                    point = point + 10
                    print("sau thang")
                }
                  bangKQ1.removeFirst()
            }
        }
        labelKetQua.text = String(point)
    }
  
    @IBAction func ClickPlayer2(_ sender: Any) {
        let numberHinh:Int = Int(arc4random_uniform(3))
        let tenhinh = khoLuuHinh[numberHinh]
        imagePlayer2.image = UIImage.init(named: tenhinh)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

