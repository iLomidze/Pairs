//
//  LocalizedString.swift
//  Pairs
//
//  Created by Irakli Lomidze on 07.08.21.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        self.localized(lang: AppSettings.shared.chosenLanguage?.rawValue)
    }
    
    func localized(lang: String? = AppSettings.shared.chosenLanguage?.rawValue) -> String {
        guard let lang = AppSettings.shared.chosenLanguage else {
            // return localized string, BASED ON THE DEVICE SYSTEM LANGUAGE
            return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
        }
        
        // return localized string BASED ON USERS CHOICE
        let path = Bundle.main.path(forResource: lang.rawValue, ofType: "lproj")
        guard let path = path else {
            print("There is no supported language for this initials")
            return self
        }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")

    }
}




