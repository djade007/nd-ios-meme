//
//  MeTextDelegate.swift
//  Meme
//
//  Created by Olajide Afeez on 26/06/2021.
//

import UIKit

class MeTextDelegate: NSObject, UITextFieldDelegate  {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.lowercased() == "top" || textField.text?.lowercased() == "bottom" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
