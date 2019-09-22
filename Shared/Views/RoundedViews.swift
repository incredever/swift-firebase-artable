//
//  RoundedViews.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = LAYER.CORNER_RADIUS
    }
}

class RedActionButton: RoundedButton {
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.175) {
                self.alpha = self.isEnabled ? 1.0 : 0.6
                self.backgroundColor = self.isEnabled ? COLOR.RED : COLOR.LIGHT_GRAY
            }
        }
    }
}

class BlueActionButton: RoundedButton {
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.175) {
                self.alpha = self.isEnabled ? 1.0 : 0.6
                self.backgroundColor = self.isEnabled ? COLOR.BLUE : COLOR.LIGHT_GRAY
            }
        }
    }
}

class RoundedShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = LAYER.CORNER_RADIUS
        layer.shadowColor = SHADOW.COLOR.cgColor
        layer.shadowOffset = SHADOW.OFFSET
        layer.shadowRadius = SHADOW.RADIUS
    }
}

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = LAYER.CORNER_RADIUS
    }
}
