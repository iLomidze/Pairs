//
//  NameTextFieldDelegate.swift
//  Pairs
//
//  Created by Irakli Lomidze on 08.08.21.
//

import Foundation
import UIKit


extension MenuController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isAuthenticated {
            saveToUserDefaults(name: textField.text ?? "")
        }
        textField.resignFirstResponder()
        return true
    }
    
    func saveToUserDefaults(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: UserDefaultKeys.playerName.rawValue)
    }
    
    func getNameFromUserDefaults() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: UserDefaultKeys.playerName.rawValue)
    }
}
