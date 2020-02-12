//
//  AuthPhoneNumberViewController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/12.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit
import FirebaseAuth

class RequestAuthPhoneNumberViewController: AdditionalUserInfoViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var requestButton: UIButton!
    private var verificationID = ""
    private var phoneNumber = ""
    
    @IBAction func onChangePhoneNumber(_ sender: UITextField) {
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        
        requestButton.isEnabled = phoneNumber.count == 11
    }

    @IBAction func onClickRequestAuthNumber(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        
        let endOfHead = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
        let endOfBody = phoneNumber.index(endOfHead, offsetBy: 4)
        
        let formedPhoneNumber = "+82\(phoneNumber[phoneNumber.startIndex ..< endOfHead])-\(phoneNumber[endOfHead ..< endOfBody])-\(phoneNumber[endOfBody ..< phoneNumber.endIndex])"
        
        self.phoneNumber = formedPhoneNumber
        
        PhoneAuthProvider.provider().verifyPhoneNumber(formedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.alert(title: "휴대폰 인증", message: "인증번호 발송 실패")
                print("휴대폰 인증번호 요청 에러 \(error)")
                return
            }
            
            guard let verificationID = verificationID else {
                self.alert(title: "휴대폰 인증", message: "인증번호 발송 실패")
                print("휴대폰 인증번호 요청 에러 VerificationID is nil")
                return
            }
            
            self.verificationID = verificationID
            self.performSegue(withIdentifier: "RequestAuthNumberSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RequestAuthNumberSegue" {
            let controller = segue.destination as? AuthPhoneNumberViewController
            controller?.verificationID = self.verificationID
            controller?.additionalUserInfoDelegate = self.additionalUserInfoDelegate
            controller?.phoneNumber = self.phoneNumber
        }
    }
}
