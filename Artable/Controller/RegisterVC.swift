//
//  RegisterVC.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
        //UI Text Fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
        // Other outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImage: UIImageView!
    @IBOutlet weak var confirmPassCheckImage: UIImageView!
    
    
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI set up
        setDelegates()
        registerButton.isEnabled = false
        addTextFieldsTargets()
    }
    
    
    
    // MARK: - Private Functions
    private func signUp() {
        
        // Unwrap 'email' and 'password' values
        guard let email = emailTextField.text, !email.isEmpty,
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else { return }
        
        activityIndicator.startAnimating()
        
        // Create new user on Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            // Check for error(s)
            if let error = error {
                print("CUSTOM ERROR: Unable to add new user to Database ~> \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
                return
            }
            
            if let user = authResult?.user {
                print("Successfully register new user: \(user)")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setDelegates() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func addTextFieldsTargets() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    private func setCheckMarksColor(to color: String) {
        passCheckImage.image = UIImage(named: color)
        confirmPassCheckImage.image = UIImage(named: color)
    }
    
    private func setCheckMarksState() {
        passCheckImage.isHidden = confirmPasswordTextField.text!.isEmpty ? true : false
        confirmPassCheckImage.isHidden = confirmPasswordTextField.text!.isEmpty ? true : false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Handle check mark visibility
        setCheckMarksState()
        
        // Handle check marks color
        passwordTextField.text == confirmPasswordTextField.text ? setCheckMarksColor(to: IMAGE.CHECK_MARK_GREEN) : setCheckMarksColor(to: IMAGE.CHECK_MARK_RED)
        
        // Handle 'register' button
        if !usernameTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !confirmPasswordTextField.text!.isEmpty {
            
            registerButton.isEnabled = passwordTextField.text == confirmPasswordTextField.text ? true : false
            
        } else {
            registerButton.isEnabled = false
        }
        
        // Handle password reset
        if passwordTextField.text == "" {
            confirmPasswordTextField.text = ""
            setCheckMarksState()
        }
    }
    


    // MARK: - IBActions
    @IBAction func registerButtonClicked(_ sender: Any) {
        signUp()
    }
    
}
