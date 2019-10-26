//
//  Extensions.swift
//  Artable
//
//  Created by Jonathan Sack on 9/22/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

// MARK: - String
extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}


// MARK: - Firestore
extension Firestore {
    var categories: Query {
        return collection("categories").order(by: "timeStamp", descending: false)
    }
    
    var cars: Query {
        return collection("products").whereField("category", isEqualTo: "Cars").order(by: "timestamp", descending: true)
    }
}

extension UIViewController {
    
    func handleFireAuthError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Oops", message: errorCode.errorMessage, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email."
        case .userNotFound:
            return "Account not found for the specific user. Please check and try again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email address."
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect"
        default:
            return "Oops, something went wrong."
        }
    }
}
