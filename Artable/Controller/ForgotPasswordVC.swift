//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by Jonathan Sack on 9/22/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: BlueActionButton!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    
    // MARK: - Functions
    @objc func textFieldDidChange(_ textField: UITextField) {
        resetButton.isEnabled = emailTextField.text!.isEmpty ? false : true
    }
    
    // MARK: - IBActions
    @IBAction func resetButtonClicked(_ sender: Any) {
        
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                
                guard error == nil else {
                    self.handleFireAuthError(error: error!)
                    return
                }
                
                // Display alert
                let alert = UIAlertController(title: "Email Verification Sent!", message: "Please check your inbox.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okayAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
