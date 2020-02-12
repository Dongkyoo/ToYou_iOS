//
//  UIViewController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/06.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func alert(title: String, message: String) {
        // TODO: 이메일 입력 및 인증 화면으로 이동
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
}
