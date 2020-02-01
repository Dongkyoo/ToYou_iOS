//
//  SignUpViewController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/01/29.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet var textFieldList: [UITextField]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sendAuthCodeButton: UIButton!
    @IBOutlet weak var authCodeSubmitButton: UIButton!
    
    private var authenticated = false
    private var verificationID = ""
    
    // 인증번호 전송 버튼 클릭
    @IBAction func clickSendAuthCode(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
//        let phoneNumber = "+8210-3367-7355"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {
            (verificationID, error) in
            if let error = error {
                print(error)
                return
            }
            
            // 인증메세지 전송 성공
            guard let verificationID = verificationID else {
                return
            }
            
            self.verificationID = verificationID
        }
    }
    
    // 가입하기 버튼 클릭
    @IBAction func clickSubmit(_ sender: UIButton) {
        
    }
    
    // 인증번호 확인 버튼 클릭
    @IBAction func clickAuth(_ sender: Any) {
        guard let authCode = authCodeTextField.text else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: authCode)
        Auth.auth().signIn(with: credential) {
            (authResult, error) in
            if let error = error {
                print("Firebase 휴대폰 인증 로그인 에러 \(error)")
                self.authenticated = false
                return
            }
            
            // 로그인 성공?
            self.authenticated = true
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        verify()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendAuthCodeButton.isEnabled = false
        authCodeSubmitButton.isEnabled = false
        submitButton.isEnabled = false
    }
    
    // 모든 값을 잘 입력했는지 확인해주는 함수
    private func verify() {
        verifyPhoneNumber()
        if !authenticated {
            checkEnterAuthCode()
        }
        
        // 가입하기 버튼 활성화 로직
        if !Utils.isEmpty(nameTextField.text) &&
            !Utils.isEmpty(idTextField.text) &&
            !Utils.isEmpty(passwordTextField.text) &&
            !Utils.isEmpty(confirmTextField.text) &&
            passwordTextField.text == confirmTextField.text &&
            authenticated {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    // 휴대폰 번호 눌렀는지 확인하는 메소드
    private func verifyPhoneNumber() {
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        
        // 휴대폰 번호 양식을 갖춘 번호를 입력했다면 인증번호 전송 버튼 활성화
        do {
            let regex = try NSRegularExpression(pattern: "010[0-9]{8}", options: [])
            let matchNumber = regex.numberOfMatches(in: phoneNumber, options: [], range: NSRange(phoneNumber.startIndex ..< phoneNumber.endIndex, in: phoneNumber))
            if matchNumber > 0 {
                sendAuthCodeButton.isEnabled = true
            } else {
                sendAuthCodeButton.isEnabled = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 인증번호를 입력했는지 확인하는 메소드
    private func checkEnterAuthCode() {
        guard let authCode = authCodeTextField.text else {
            return
        }
        
        if authCode.count == 6 {
            authCodeSubmitButton.isEnabled = true
        } else {
            authCodeSubmitButton.isEnabled = false
        }
    }
}
