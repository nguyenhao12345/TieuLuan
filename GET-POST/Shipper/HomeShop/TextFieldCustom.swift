//
//  TextFieldCustom.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 10/30/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import UIKit

protocol TextFieldCustomDelegate {
    func beganTouch(keyText: TextFieldCustom)
    func endedTouch(keyText: TextFieldCustom)
   
}

class TextFieldCustom: UITextField {
    var delegateTextField: TextFieldCustomDelegate?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegateTextField?.beganTouch(keyText: self)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegateTextField?.endedTouch(keyText: self)
    }
}
