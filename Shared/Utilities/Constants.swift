//
//  Constants.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit

struct COLOR {
    static let BLUE = UIColor(red: 58/255, green: 68/255, blue: 92/255, alpha: 1)
    static let RED = UIColor(red: 213/255, green: 100/255, blue: 80/255, alpha: 1)
    static let OFF_WHITE = UIColor(red: 243/255, green: 242/255, blue: 247/255, alpha: 1)
    static let LIGHT_GRAY = UIColor.lightGray
}

struct LAYER {
    static let CORNER_RADIUS: CGFloat = 5
}

struct SHADOW {
    static let COLOR = UIColor(red: 58/255, green: 68/255, blue: 92/255, alpha: 1)
    static let OPACITY: Double = 0.4
    static let OFFSET: CGSize = CGSize.zero
    static let RADIUS: CGFloat = 3
}

struct IMAGE {
    static let CHECK_MARK_RED: String = "red_check"
    static let CHECK_MARK_GREEN: String = "green_check"
}
