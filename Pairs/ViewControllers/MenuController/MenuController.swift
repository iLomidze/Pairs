//
//  MenuController.swift
//  Pairs
//
//  Created by Irakli Lomidze on 06.08.21.
//

import LocalAuthentication
import UIKit

class AppSettings {
    
    static let shared: AppSettings = AppSettings()
    
    private init() {}
    
    var chosenLanguage: AppLanguage?
}

class MenuController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var AuthenticateButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addPairsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var highScoresButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    // MARK: - Properties
    
    let fileName = "pairWords"
    var isAuthenticated = false {
        didSet {
            authenticationUpdate(status: isAuthenticated)
        }
    }
    var languagePicked: String?
    var isFirebaseLogedIn = false
    var emailAddress: String?
    
    

    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.isEnabled = false
        addPairsButton.isEnabled = false
        logOutButton.isHidden = true
        changePasswordButton.isHidden = true
        
        
        if let currentLanguage = Locale.current.languageCode {
            languagePicked = currentLanguage
        }
        setCorrectLanguageForPickAndApp()
    }
    
    func setLanguage(language: AppLanguage?) {
        AppSettings.shared.chosenLanguage = language
        localizeStoryboard()
    }
    
    
    // MARK: - Methods
    
    /// prints every pair in saved file - for debug mainly
    func printTextFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName+".txt")
        do {
            let txt = try String(contentsOf: fileURL!)
            print(txt)
        } catch {
            print("Cant read it!!!")
        }
    }
    
    ///
    func savePairToFile(in fileName: String, word1: String, word2: String) {
        let line = "\(word1) \(word2)\n"
        let data = line.data(using: .utf8)!
        
        let fileManager = FileManager.default
        if let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName+".txt") {
            if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
            }
            else {
                print("MenuController -", "Cant add pair to the text file")
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func authenticationUpdate(status: Bool) {
        if isAuthenticated {
            nameTextField.isEnabled = true
            addPairsButton.isEnabled = true
            logOutButton.isHidden = false
            AuthenticateButton.isHidden = true
            changePasswordButton.isHidden = false
            
            emailFirebaseLogin()
            
        } else {
            nameTextField.isEnabled = false
            addPairsButton.isEnabled = false
            logOutButton.isHidden = true
            AuthenticateButton.isHidden = false
            changePasswordButton.isHidden = true
            nameTextField.text = ""
        }
    }
    
    func emailFirebaseLogin() {
        let ac = UIAlertController(title: "Network Login".localized, message: "For this moment Sign with Apple is not available,\nplease proceed to the email authentication in order to store your high score".localized, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Offline".localized, style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Email Log In".localized, style: .default, handler: { [weak self] action in
            guard let vc = self?.storyboard?.instantiateViewController(identifier: "AuthenticationController") as? AuthenticationController else { return }
            
            vc.languagePicked = self?.languagePicked
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    /// This is required because storyboard translates string based on the device system language - which may change via language picker
    func localizeStoryboard() {
        AuthenticateButton.setTitle("Authenticate".localized, for: .normal)
        addPairsButton.setTitle("Add Pairs".localized, for: .normal)
        logOutButton.setTitle("Log Out".localized, for: .normal)
        playGameButton.setTitle("Play Game".localized, for: .normal)
        highScoresButton.setTitle("High Scores".localized, for: .normal)
        changePasswordButton.setTitle("Change Password".localized, for: .normal)
        
        if nameTextField.text?.isEmpty ?? false {
            nameTextField.placeholder = "Player Name".localized
        }
    }
    
    /// lets user enter password and it saves it afterwards
    func setPassword() {
        let ac = UIAlertController(title: "Set Password".localized, message: "This password is for additional safety reasons, which may be used in special cases".localized, preferredStyle: .alert)
        ac.addTextField { textfield in
            textfield.placeholder = "Enter Password".localized
            textfield.isSecureTextEntry = true
        }
        ac.addTextField { textfield in
            textfield.placeholder = "Confirm Password".localized
            textfield.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Set Password".localized, style: .default, handler: { [weak self] _ in
            guard let word1 = ac.textFields?.first?.text, !word1.isEmpty,
                  let word2 = ac.textFields?[1].text, !word2.isEmpty
                  else {
                    return
                  }
            if word1 == word2 {
                self?.savePassword(password: word1)
            }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    /// saves password in  to keychain
    func savePassword(password: String) {
        KeychainWrapper.standard.set(password, forKey: KeyChainKeys.password.rawValue)
    }
    
    /// returns password or nil (if it doesn't exist) from keychain
    func getPassword() -> String? {
        return KeychainWrapper.standard.string(forKey: KeyChainKeys.password.rawValue)
    }
    
    
    
    
    // MARK: - Outlet Actions
    
    @IBAction func AuthenticateButtonAction(_ sender: Any) {
        // Set hard password
        if getPassword() == nil {
            setPassword()
            return
        }
        
        // Biometric authentication
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!".localized

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.isAuthenticated = true
                        
                        self?.nameTextField.text = self?.getNameFromUserDefaults() ?? ""
                    } else {
                        print("MenuController - Biometric Authentication failed -", authenticationError?.localizedDescription ?? "Error N/A")
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "No Biometrics Available".localized, message: "Please choose password option to authenticate".localized, preferredStyle: .alert)
            ac.addTextField { textfield in
                textfield.placeholder = "Enter Password".localized
                textfield.isSecureTextEntry = true
            }
            ac.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Use Password".localized, style: .default, handler: { [weak self] _ in
                if ac.textFields?.first?.text == self?.getPassword() {
                    self?.isAuthenticated = true
                } else {
                    self?.AuthenticateButton.setTitleColor(.red, for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self?.AuthenticateButton.setTitleColor(UIColor(named: "fontColor"), for: .normal)
                    }
                }
            }))
            present(ac, animated: true, completion: nil)
        }
    }
    
    @IBAction func addPairsButtonAction(_ sender: Any) {
        let ac = UIAlertController(title: "Enter Pairs".localized, message: "Enter 2 associated words".localized(lang: languagePicked), preferredStyle: .alert)
        
        ac.addTextField { curTextField in
            curTextField.placeholder = "Enter Word 1".localized
        }
        ac.addTextField { curTextField in
            curTextField.placeholder = "Enter Word 2".localized
        }
        
        ac.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Add".localized, style: .default, handler: { [weak self] action in
            guard let textField1 = ac.textFields?.first, let textField2 = ac.textFields?[1] else { return }
            guard let fileName = self?.fileName else { return }
            guard let word1 = textField1.text, let word2 = textField2.text else { return }
            
            if textField1.text == "" || textField2.text == "" { return }
            if word1.components(separatedBy: .whitespaces).count != 1 || word2.components(separatedBy: .whitespaces).count != 1 { return }
            
            self?.savePairToFile(in: fileName, word1: textField1.text!, word2: textField2.text!)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonAction(_ sender: Any) {
        isAuthenticated = false
    }
    
    @IBAction func playGameButtonAction(_ sender: Any) {
        guard let gameController = storyboard?.instantiateViewController(identifier: "GameController") as? GameController else { return }
        
        gameController.isFirebaseLogedIn = isFirebaseLogedIn
        gameController.emailAddress = emailAddress
        
        navigationController?.pushViewController(gameController, animated: true)
    }
    
    @IBAction func highScoresButtonAction(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "HighScoreController") as? HighScoreController else { return }
        
        vc.languagePicked = languagePicked
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        let ac = UIAlertController(title: "Change Password".localized, message: nil, preferredStyle: .alert)
    
        ac.addTextField { textfield in
            textfield.placeholder = "Enter Current Password".localized
            textfield.isSecureTextEntry = true
        }
        ac.addTextField { textfield in
            textfield.placeholder = "Enter Password".localized
            textfield.isSecureTextEntry = true
        }
        ac.addTextField { textfield in
            textfield.placeholder = "Confirm Password".localized
            textfield.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Set Password".localized, style: .default, handler: { [weak self] _ in
            guard let currentPassword = ac.textFields?.first?.text, !currentPassword.isEmpty,
                  let newPassword1 = ac.textFields?[1].text, !newPassword1.isEmpty,
                  let newPassword2 = ac.textFields?[2].text, !newPassword2.isEmpty
                  else {
                    return
                  }
            if currentPassword == self?.getPassword() && newPassword1 == newPassword2 {
                self?.savePassword(password: newPassword1)
            }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    
    // END CLASS
}
