//
//  CardView.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/01/29.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: -15, height: 20)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }

}
