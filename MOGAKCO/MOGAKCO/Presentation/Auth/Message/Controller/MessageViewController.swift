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
            .withUnretained(self)
            .bind { (vc, value) in
                vc.verify(value)
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
    func verify(_ code: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }

        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: code)
        
        requestLogin(credential)
    }
    
    func requestLogin(_ credential: PhoneAuthCredential) {
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("가입실패", error.localizedDescription)
                }
                print("가입 성공", authResult)
            }
        }
}
