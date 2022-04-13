//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Eyvind on 24/3/22.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var defaultText: String
    var isDefultTextSet:Bool
    
    init(defaultText:String) {
        self.defaultText = defaultText
        self.isDefultTextSet = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isDefultTextSet {
            textField.text = ""
            isDefultTextSet = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setText(_ textField: UITextField, _ text:String) {
        textField.text = text
        isDefultTextSet = false
    }
    
    func resetTextField(_ textField: UITextField){
        textField.text = defaultText
        textField.placeholder = defaultText
        self.isDefultTextSet = true
    }
    
}
