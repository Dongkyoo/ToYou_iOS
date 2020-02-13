//
//  MainTabBarController.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/12.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        do {
            guard let userData = UserDefaults.standard.object(forKey: USER) as? Data else {
                return
            }
            
            let user = try PropertyListDecoder().decode(User.self, from: userData)
            self.appDelegate().user = user
        } catch let error {
            print("자동로그인 에러 \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !checkSignIn() {
            let storyboard = UIStoryboard(name: "Entrance", bundle: .main)
            let controller = storyboard.instantiateViewController(identifier: "SignInViewController")
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: 로그인 확인하는 메소드
    private func checkSignIn() -> Bool {
        return self.appDelegate().user != nil
    }
}
