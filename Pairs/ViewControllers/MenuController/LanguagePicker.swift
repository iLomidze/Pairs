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
        guard let currentLanguage = Locale.current.languageCode,
              let appLang = AppLanguage(rawValue: currentLanguage) else { return }
        
        self.setLanguage(language: appLang)
        self.pickerView.selectRow(appLang.index, inComponent: 0, animated: false)
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
        guard let lang = AppLanguage.language(forIndex: row) else { return }
        self.setLanguage(language: lang)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        var rowString = String()
        
        guard let appLang = AppLanguage.language(forIndex: row) else { return UIView() }
        
        rowString = appLang.description
        myImageView.image = UIImage(named: appLang.assetName)
        
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60 ))
        myLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)

        return myView
    }
    
    // END CLASS
}
