//
//  SignUpDelegate.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/12.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import Foundation

protocol AdditionalUserInfoDelegate {
    
    // MARK: 다음 신으로 이동하기위한 메소드를 구현해야함
    func onNextScene(_ data: Any, from sender: AdditionalUserInfoViewController)
    
}
