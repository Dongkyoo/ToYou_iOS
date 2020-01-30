//
//  Utils.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/01/31.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func vibrate(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    static func isEmpty(_ str: String?) -> Bool {
        return str == nil || str == ""
    }
}
