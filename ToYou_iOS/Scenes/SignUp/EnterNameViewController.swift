//
//  EnterNameViewController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/12.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit

class EnterNameViewController: AdditionalUserInfoViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func onChangeName(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        submitButton.isEnabled = name.count > 0
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        guard let signUpDelegate = self.additionalUserInfoDelegate else {
            return
        }
        
        guard let name = nameTextField.text else {
            return
        }
        
        signUpDelegate.onNextScene(name, from: self)
    }
}
