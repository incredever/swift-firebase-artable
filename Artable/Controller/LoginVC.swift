//
//  LoginVC.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        addTextFieldTargets()
    }
    
    
    // MARK: - Functions
    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func addTextFieldTargets() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Handle Login button
        loginButton.isEnabled = !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty ? true : false
        
        // Handle password text field
        if emailTextField.text!.isEmpty {
            passwordTextField.text = ""
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        // Star animation
        activityIndicator.startAnimating()
        
        // Attempt login
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            // Handle error(s)
            guard error == nil else {
                self?.handleFireAuthError(error: error!)
                strongSelf.handleFireAuthError(error: error!)
                strongSelf.activityIndicator.stopAnimating()
                return
            }
            
            if let _ = user {
                print("Login successful")
                self?.dismiss(animated: true, completion: nil)
            }
            strongSelf.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: UIButton) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func continueGuestButton(_ sender: UIButton) {
    }
    
}
