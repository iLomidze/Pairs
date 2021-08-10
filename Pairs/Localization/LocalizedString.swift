//
//  LocalizedString.swift
//  Pairs
//
//  Created by Irakli Lomidze on 07.08.21.
//

import Foundation
import UIKit

extension String {
    
    func localized(lang: String? = nil) -> String {
        guard let lang = lang else {
            // return localized string, BASED ON THE DEVICE SYSTEM LANGUAGE
            return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
        }
        
        // return localized string BASED ON USERS CHOICE
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        guard let path = path else {
            print("There is no supported language for this initials")
            return self
        }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")

    }
    
    // END CLASS
}
