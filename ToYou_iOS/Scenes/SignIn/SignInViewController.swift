//
//  ViewController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/01/28.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit
import Firebase
import KakaoOpenSDK

let USER = "user"

class SignInViewController: UIViewController, AdditionalUserInfoDelegate {

    private var additionalUserInfoControllerList: [AdditionalUserInfoViewController]?
    
    
    // 카카오 로그인 버튼 클릭
    @IBAction func onClickLoginWithKakao(_ sender: KOLoginButton) {
        
        guard let kakaoSession = KOSession.shared() else {
            return
        }
        
        kakaoSession.open { e in
            if let error = e {
                self.alert(title: "이미 로그인되어있습니다.", message: "로그아웃되었습니다.")
                print("카카오 로그인 에러 \(error)")
                kakaoSession.logoutAndClose { (flag, error) in
                    if let error = error {
                        print("카카오 로그아웃 에러 \(error)")
                        return
                    }
                    
                    print("카카오 로그아웃 \(flag)")
                }
                return
            }
            
            if kakaoSession.isOpen() {
                KOSessionTask.userMeTask { (e, me) in
                    if let error = e {
                        print("카카오 사용자 정보 받아오는 중 에러 발생 \(error)")
                        
                        return
                    }
                    
                    guard let me = me else {
                        return
                    }
                    
                    guard let account = me.account else {
                        return
                    }
                    
                    // 이메일이 등록되어 있지 않은 경우
                    guard let email = account.email else {
                        // TODO: 이메일 입력 및 인증 화면으로 이동
                        self.alert(title: "로그인 실패", message: "이메일이 등록되어 있지 않습니다.")
                        return
                    }
                    
                    // 이메일은 등록되어 있으나 인증이 되어 있지 않은 경우
                    if account.isEmailVerified != .true {
                        // TODO: 이메일 인증
                        self.alert(title: "로그인 실패", message: "이메일 인증이 필요합니다. 카카오톡 계정의 이메일 인증을 진행하고 로그인해주세요.")
                        return
                    }
                    
                    let storyboard = UIStoryboard(name: "Entrance", bundle: .main)
                    
                    // 이름 정보 입력 받기
                    let name = account.legalName
                    if name == nil {
                        guard let controller = storyboard.instantiateViewController(identifier: "EnterNameController") as? AdditionalUserInfoViewController else {
                            return
                        }
                        controller.additionalUserInfoDelegate = self
                        
                        if self.additionalUserInfoControllerList == nil {
                            self.additionalUserInfoControllerList = [AdditionalUserInfoViewController]()
                        }
                        self.additionalUserInfoControllerList?.append(controller)
                    }
                    
                    // 휴대폰 번호 입력 받기
                    let phoneNumber = account.phoneNumber
                    if phoneNumber == nil {
                        guard let controller = storyboard.instantiateViewController(identifier: "RequestAuthPhoneNumberViewController") as? AdditionalUserInfoViewController else {
                            return
                        }
                        
                        controller.additionalUserInfoDelegate = self
                        
                        if self.additionalUserInfoControllerList == nil {
                            self.additionalUserInfoControllerList = [AdditionalUserInfoViewController]()
                        }
                        self.additionalUserInfoControllerList?.append(controller)
                    }
                    
                    if account.gender == KOUserGender.null {
                        // TODO: 성별 입력
                        self.alert(title: "로그인 실패", message: "성별이 등록되어있지 않습니다.")
                        return;
                    }
                    
                    // 이미 가입된 유저인지 확인
                    let docRef = self.appDelegate().db.collection(USERS).document(email)
                    
                    docRef.getDocument { (document, error) in
                        if let error = error {
                            print("유저 데이터 로딩 중 에러 \(error)")
                            return
                        }
                        
                        if let document = document, document.exists {
                            // 이미 가입된 유저라면 로그인 처리 후 메인화면으로 이동
                            if let dataMap = document.data() {
                                let user = User(dataMap)
                                self.signIn(user: user)
                            }
                            
                            // 신규 가입
                            else {
                                self.appDelegate().user = User(id: email, phoneNumber: phoneNumber, name: name, partner: nil, createdAt: Date(), gender: account.gender == KOUserGender.male ? .male : .female)
                                self.signUp(self.additionalUserInfoControllerList)
                            }
                        } else {
                            self.appDelegate().user = User(id: email, phoneNumber: phoneNumber, name: name, partner: nil, createdAt: Date(), gender: account.gender == KOUserGender.male ? .male : .female)
                            self.signUp(self.additionalUserInfoControllerList)
                        }
                    }
                }
            } else {
                print("카카오 세션 열리지 않음")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            guard let userData = UserDefaults.standard.object(forKey: USER) as? Data else {
                return
            }
            
            let user = try PropertyListDecoder().decode(User.self, from: userData)
            signIn(user: user)
        } catch let error {
            print("자동로그인 에러 \(error)")
        }
    }
    
    // MARK: 회원가입, additionalUserInfoControllerList 가 nil이면 회원가입을 정상적으로 시도한다.
    private func signUp(_ additionalUserInfoControllerList: [AdditionalUserInfoViewController]?) {
        if let additionalUserInfoControllerList = additionalUserInfoControllerList {
            self.navigationController?.pushViewController(additionalUserInfoControllerList[0], animated: true)
            
            return
        }
        
        // Firebase DB 저장
        let user = self.appDelegate().user!
        self.appDelegate().db.collection(USERS).document(user.id).setData(user.decode())
    }
    
    // MARK: 로그인
    private func signIn(user: User) {
        do {
            self.appDelegate().user = user
            // UserDefaults 저장 (자동로그인)
            let encodedData = try PropertyListEncoder().encode(user)
            UserDefaults.standard.set(encodedData, forKey: USER)
            
            moveToMainScene()
        } catch let error {
            print("자동로그인 정보 저장 에러 \(error)")
        }
    }
    
    func onNextScene(_ data: Any, from sender: AdditionalUserInfoViewController) {
        
        var index = 0
        guard let additionalUserInfoControllerList = self.additionalUserInfoControllerList else {
            return
        }
        for controller in additionalUserInfoControllerList {
            if controller == sender {
                break
            }
            index += 1
        }
        
        // 이름
        if sender.isKind(of: EnterNameViewController.self) {
            self.appDelegate().user.name = data as? String
        }
        
        // 휴대폰번호
        else if sender.isKind(of: AuthPhoneNumberViewController.self) {
            self.appDelegate().user.phoneNumber = data as? String
        }
        
        if index < additionalUserInfoControllerList.count - 1 {
            self.navigationController?.pushViewController(additionalUserInfoControllerList[index + 1], animated: true)
        } else {
            signUp(nil)
            self.navigationController?.popToRootViewController(animated: false)
            
            signIn(user: self.appDelegate().user)
        }
    }
    
    // MARK: 메인화면으로 이동
    private func moveToMainScene() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let controller = storyboard.instantiateViewController(identifier: "MainTabBarController")
        self.present(controller, animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
