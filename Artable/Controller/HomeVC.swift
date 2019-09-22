//
//  ViewController.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginLogoutButton: UIBarButtonItem!
    
    
    
    // MARK: - Variables
    var firebase: NSObjectProtocol?
    
    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sign user in
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    print("CUSTOM ERROR: Unable to Sign-in anonymously ~> \(error.localizedDescription)")
                } else {
                  print("Signed in anonymously")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = Auth.auth().currentUser {
            loginLogoutButton.title = "Logout"
        } else {
            loginLogoutButton.title = "Login"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firebase = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(firebase!)
    }
    
    
    
    // MARK: - Functions
    func presentLoginVC() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginVC")
        present(controller, animated: true, completion: nil)
    }
    


    // MARK: - IBActions
    @IBAction func loginLogoutButtonClicked(_ sender: Any) {
        
        // User log out
        if let _ = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
                presentLoginVC()
            } catch {
                print("CUSTOM ERROR: Unable to sign out ~> \(error.localizedDescription)")
            }
        }
        presentLoginVC()
    }
    
}

