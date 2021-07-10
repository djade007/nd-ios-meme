//
//  MeTextDelegate.swift
//  Meme
//
//  Created by Olajide Afeez on 26/06/2021.
//

import UIKit

class MeTextDelegate: NSObject, UITextFieldDelegate  {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Remove only default texts when a user taps the text field
        if textField.text?.lowercased() == "top" || textField.text?.lowercased() == "bottom" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
}
