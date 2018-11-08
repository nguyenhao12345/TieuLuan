//
//  CheckSpecialCharacter.swift
//  GET-POST
//
//  Created by Nguyen Hieu on 11/8/18.
//  Copyright © 2018 datnguyen. All rights reserved.
//

import Foundation
class CheckSpecialCharacter {
    static let share = CheckSpecialCharacter()
    func checkCharacter(string: String) -> Bool {
        for character in string.utf8 {
            if character < 48 || (character > 57 && character < 65) || (character > 90 && character < 97) || character > 122  {
                return true
            }
        }
        return false
    }
    func checkCharacterIsNumber(string: String) -> Bool {
        for character in string.utf8 {
            if character > 47 && character < 58  {
                return false
            }
        }
        return true
    }
}
