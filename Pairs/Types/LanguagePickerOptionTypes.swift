//
//  LanguagePickerOptionTypes.swift
//  Pairs
//
//  Created by Irakli Lomidze on 08.08.21.
//

import Foundation
import UIKit

enum AppLanguage: String {
    case en, ka
    
    static func language(forIndex index: Int) -> AppLanguage? {
        if index == 0 {
            return .en
        } else if index == 1 {
            return .ka
        }
        return nil
    }
    
    var index: Int {
        switch self {
        case .en:
            return 0
        case .ka:
            return 1
        }
    }
    
    var description: String {
        switch self {
        case .en:
            return "English"
        case .ka:
            return "ქართული"
        }
    }
    
    var assetName: String {
        return "ic_lang_\(self.rawValue)"
    }
}
