//
//  ActionButton.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.175) {
                self.alpha = self.isEnabled ? 1.0 : 0.6
                self.backgroundColor = self.isEnabled ? UIColor(red: 213/255, green: 100/255, blue: 80/255, alpha: 1.0) : .lightGray
            }
        }
    }
}
