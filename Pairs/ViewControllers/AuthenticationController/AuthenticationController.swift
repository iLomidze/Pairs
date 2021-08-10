//
//  AuthenticationController.swift
//  Pairs
//
//  Created by Irakli Lomidze on 08.08.21.
//

import UIKit
import FirebaseAuth

class AuthenticationController: UIViewController {

    // MARK: - Outlets
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "fontColor")
        return label
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.textColor = UIColor(named: "fontColor")
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.isSecureTextEntry = true
        passwordField.autocorrectionType = .no
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.textColor = UIColor(named: "fontColor")
        return passwordField
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "fontColor")
        return label
    }()
    
    
    // MARK: - Properties
    
    var languagePicked: String?
        
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(logInButton)
        view.addSubview(logOutButton)
        view.addSubview(playerNameLabel)
     
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        
        logOutButton.isHidden = true
        playerNameLabel.isHidden = true
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            updateUI(isLoggedIn: true)
            sendFirebaseLogInStatusToMainController(status: true)
            if let emailAddress = playerNameLabel.text {
                sendEmailAddressToMainController(emailAddress: emailAddress)
            }
            
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0,
                             y: 100,
                             width: view.frame.size.width,
                             height: 80)
        label.text = "Log In".localized(lang: languagePicked)
        
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width - 40,
                                  height: 50)
        emailField.placeholder = "Email Address".localized(lang: languagePicked)
        
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.frame.origin.y+label.frame.size.height+10,
                                     width: view.frame.size.width-40,
                                     height: 50)
        passwordField.placeholder = "Password".localized(lang: languagePicked)
        
        logInButton.frame = CGRect(x: 20,
                              y: passwordField.frame.origin.y+label.frame.size.height+30,
                              width: view.frame.size.width - 40,
                              height: 52)
        logInButton.setTitle("Continue".localized(lang: languagePicked), for: .normal)
        
        logOutButton.frame = CGRect(x: 20,
                                     y: 250,
                                     width: view.frame.size.width-40,
                                     height: 52)
        logOutButton.setTitle("Log Out".localized(lang: languagePicked), for: .normal)
        
        playerNameLabel.frame = label.frame
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailField.becomeFirstResponder()
        }
    }
    
    
    
    // MARK: - Methods
    
    ///
    func showCreateAccount(email: String, password: String) {
        let ac = UIAlertController(title: "Create Account".localized(lang: languagePicked), message: "Would you like to create account?".localized(lang: languagePicked), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue".localized(lang: languagePicked), style: .default, handler: { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    print("AuthenticationController -", "Cant log in after creating account")
                    return
                }
                
                strongSelf.updateUI(isLoggedIn: true)
                strongSelf.sendFirebaseLogInStatusToMainController(status: true)
                
                strongSelf.emailField.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel".localized(lang: languagePicked), style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    ///
    func updateUI(isLoggedIn: Bool) {
        if isLoggedIn {
            label.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true
            logInButton.isHidden = true
            logOutButton.isHidden = false
            playerNameLabel.isHidden = false
            playerNameLabel.text = FirebaseAuth.Auth.auth().currentUser?.email
        } else {
            label.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            logInButton.isHidden = false
            logOutButton.isHidden = true
            playerNameLabel.isHidden = true
        }
    }
    
    ///
    func sendFirebaseLogInStatusToMainController(status: Bool) {
        guard let vcRoot = navigationController?.viewControllers.first as? MenuController else { return }
        vcRoot.isFirebaseLogedIn = status
    }

    ///
    func sendEmailAddressToMainController(emailAddress: String) {
        guard let vcRoot = navigationController?.viewControllers.first as? MenuController else { return }
        vcRoot.emailAddress = emailAddress
    }
    
    
    
    // MARK: - Outlet Actions
    
    @objc func logInButtonAction() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing Field Data")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                #warning("The description may change")
                if error?.localizedDescription == FirebaseAuthErrorTypes.incorrectPassword.rawValue {
                    strongSelf.emailField.backgroundColor = .red
                    strongSelf.passwordField.backgroundColor = .red
                    strongSelf.view.isUserInteractionEnabled = false
                    
                    let ac = UIAlertController(title: "Wrong password", message: error?.localizedDescription, preferredStyle: .alert)
                    strongSelf.present(ac, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                        strongSelf.emailField.backgroundColor = .white
                        strongSelf.passwordField.backgroundColor = .white
                        strongSelf.passwordField.text = ""
                        strongSelf.view.isUserInteractionEnabled = true
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                } else if error?.localizedDescription == FirebaseAuthErrorTypes.manyPasswordTimes.rawValue {
                    strongSelf.emailField.backgroundColor = .red
                    strongSelf.passwordField.backgroundColor = .red
                    strongSelf.view.isUserInteractionEnabled = false
                    
                    let ac = UIAlertController(title: "Too many tries", message: error?.localizedDescription, preferredStyle: .alert)
                    strongSelf.present(ac, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                        strongSelf.emailField.backgroundColor = .white
                        strongSelf.passwordField.backgroundColor = .white
                        strongSelf.passwordField.text = ""
                        strongSelf.view.isUserInteractionEnabled = true
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                } else {
                    strongSelf.showCreateAccount(email: email, password: password)
                }
                return
            }
            
            strongSelf.updateUI(isLoggedIn: true)
            strongSelf.sendFirebaseLogInStatusToMainController(status: true)
            
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
        }
    }
    
    @objc func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            updateUI(isLoggedIn: false)
            passwordField.text = ""
            sendFirebaseLogInStatusToMainController(status: false)
        }
        catch {
            print("AuthenticationController -", "An error occurred" )
        }
    }
    
    
    // END CLASS
}
