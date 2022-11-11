//
//  MessageViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MessageViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let messageView = MessageView()
    private let messageViewModel = MessageViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = messageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        checkCurrentUser()
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = MessageViewModel.Input(messageText: messageView.textField.rx.text, tap: messageView.reuseView.okButton.rx.tap)
        let output = messageViewModel.transform(input)
                
        output.messageText
            .bind(to: messageView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.messageValid
            .drive(messageView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.messageText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { (vc, code) in
//                vc.verifyID(code)
                print(code)
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { (vc,_) in
                vc.pushNicknameView()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushNicknameView() {
        let viewController = NicknameViewController()
        self.transition(viewController, .push)
    }
}

// MARK: - Firebase Auth

extension MessageViewController {
    func verifyID(_ code: String) {
        guard let verificationID = UserManager.verificationID else { return }

        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: code)
        
        signinFirebase(credential)
    }
    
    func signinFirebase(_ credential: PhoneAuthCredential) {
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("🔴Firebase 회원가입 실패", error.localizedDescription)
                }
                print("🟢Firebase 회원가입 성공", authResult as Any)
            }
        }
    
    func checkCurrentUser() { // 파이어베이스에 해당 사용자가 기존 사용자인지 체크 -> 그렇다면 토큰이 있을거고 -> 토큰 가져옴
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
              print("🔴Firebase idToken 가져오기 실패 = 기존 유저 아님", error.localizedDescription)
            return
          }
            guard let idToken = idToken else { return }
            // 토큰을 SSAC 서버에게 보내야 함
            print("🟢Firebase idToken ->>>", idToken)
            UserDefaults.standard.set(idToken, forKey: Matrix.idToken)
        }
    }
}
