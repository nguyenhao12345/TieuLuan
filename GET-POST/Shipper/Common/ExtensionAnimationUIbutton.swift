//
//  Extension.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 10/14/18.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func rootUIStoryboard() {
        guard let share = UIApplication.shared.delegate as? AppDelegate else { return }
        let navigationController = UINavigationController(rootViewController: self)
        
        navigationController.isToolbarHidden = true
        share.window?.rootViewController = navigationController
        share.window?.makeKeyAndVisible()
    }
}

extension UIButton {
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 0
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x, y: center.y+10)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x, y: center.y-10)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.7
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.1
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }

}
