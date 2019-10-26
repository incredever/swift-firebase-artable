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
    private func registerUser() {
        
        // Unwrap 'email' and 'password' values
        guard let email = emailTextField.text, !email.isEmpty,
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else { return }
        
        activityIndicator.startAnimating()
        
        // Check current user (anonymous)
        guard let userAuth = Auth.auth().currentUser else {
            activityIndicator.stopAnimating()
            return
        }
        
        // Create credentials
        let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // Link credentials to current anonymous user
        userAuth.link(with: credentials) { (result, error) in
            // Check for error(s)
            if let error = error {
                self.handleFireAuthError(error: error)
                self.activityIndicator.stopAnimating()
                return
            }
            
            print("New user successfully registered.")
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
        
//        // Create new user on Firebase
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//
//
//
//        }
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
    
    private func setCheckMarksColor(for imageView: UIImageView, to color: String) {
        imageView.image = UIImage(named: color)
    }
    
    private func setCheckMarksState() {
        passCheckImage.isHidden = passwordTextField.text!.isEmpty ? true : false
        confirmPassCheckImage.isHidden = confirmPasswordTextField.text!.isEmpty ? true : false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Handle check mark visibility
        setCheckMarksState()
        
        // Handle password check mark color
        passwordTextField.text!.count >= 6 ? setCheckMarksColor(for: passCheckImage, to: IMAGE.CHECK_MARK_GREEN) : setCheckMarksColor(for: passCheckImage, to: IMAGE.CHECK_MARK_RED)
        
        // Handle confirm password check mark color
        passwordTextField.text == confirmPasswordTextField.text ? setCheckMarksColor(for: confirmPassCheckImage, to: IMAGE.CHECK_MARK_GREEN) : setCheckMarksColor(for: confirmPassCheckImage, to: IMAGE.CHECK_MARK_RED)
        
        // Handle 'register' button
        if !usernameTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !confirmPasswordTextField.text!.isEmpty && passwordTextField.text!.count > 5 {
            
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
        registerUser()
    }
    
}

