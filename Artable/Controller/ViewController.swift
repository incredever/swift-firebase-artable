//
//  ViewController.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: - Variables
    var firebase: NSObjectProtocol?
    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginVC")
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firebase = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(firebase!)
    }
    



}

