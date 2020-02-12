//
//  AuthPhoneNumberViewController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/12.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthPhoneNumberViewController: AdditionalUserInfoViewController {

    var verificationID: String!
    var phoneNumber: String!
    
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func onAuthNumberChange(_ sender: Any) {
        guard let authNumber = authNumberTextField.text else {
            return
        }
        
        submitButton.isEnabled = authNumber.count > 0
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        guard let authNumber = authNumberTextField.text else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: authNumber)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.alert(title: "휴대폰 인증 에러", message: "인증번호를 확인해주세요.")
                print("로그인 에러 \(error)")
            }
            
            self.additionalUserInfoDelegate?.onNextScene(self.phoneNumber, from: self)
        }
    }
}
