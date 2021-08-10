//
//  PickerViewController.swift
//  Pairs
//
//  Created by Irakli Lomidze on 07.08.21.
//

import Foundation
import UIKit


extension MenuController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Methods
    
    /// Based on the device system language it selects correct row on language picker. If the device system  language is not implemented - it sets English
    func setCorrectLanguageForPickAndApp() {
        guard let currentLanguage = Locale.current.languageCode else { return }
        
        if currentLanguage == "ka" {
            pickerView.selectRow(LanguagePickerOptionTypes.GEO.rawValue, inComponent: 0, animated: true)
            languagePicked = currentLanguage
        } else {
            pickerView.selectRow(LanguagePickerOptionTypes.ENG.rawValue, inComponent: 0, animated: true)
            languagePicked = "en"
        }
    }
    
    
    // MARK: - DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case LanguagePickerOptionTypes.ENG.rawValue:
            languagePicked = "en"
            localizeStoryboard()
        case LanguagePickerOptionTypes.GEO.rawValue:
            languagePicked = "ka"
            localizeStoryboard()
        default:
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        var rowString = String()
        switch row {
        case LanguagePickerOptionTypes.ENG.rawValue:
            rowString = "ENG"
            myImageView.image = UIImage(named:"eng")
        case LanguagePickerOptionTypes.GEO.rawValue:
            rowString = "GEO"
            myImageView.image = UIImage(named:"geo")
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60 ))
        myLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)

        return myView
    }
    
    // END CLASS
}
