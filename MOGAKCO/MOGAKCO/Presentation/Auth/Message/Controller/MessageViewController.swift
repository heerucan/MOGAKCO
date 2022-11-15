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
            .bind { (vc, code) in
                vc.verifyID(code)
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (vc, isValid) in
                isValid ? vc.requestLogin() : vc.showToast(ToastMatrix.phoneTypeError.description)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Network
    
    // TODO: - 리팩토링 시급한 부분
    private func requestLogin() {
        APIManager.shared.requestData(Login.self, AuthRouter.login) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                print("🟣Login Response Data ->>> \n", value)
                self.handle(with: .success)
                let vc = HomeViewController()
                self.transition(vc, .push)
                
            case .failure(let error):
                self.handle(with: error)
            }
        }
    }
}

// MARK: - Firebase Auth

extension MessageViewController {
    private func verifyID(_ code: String) {
        let verificationID = UserDefaultsHelper.standard.verificationID!
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code)
        self.signInFirebase(credential)
    }
    
    private func signInFirebase(_ credential: PhoneAuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("🔴Firebase 회원가입 실패", error.localizedDescription)
            } else {
                print("🟢Firebase 회원가입 성공", authResult as Any)
                self.checkUser()
            }
        }
    }
    
    func checkUser() { // 파이어베이스에 해당 사용자가 기존 사용자인지 체크 -> 그렇다면 토큰이 있을거고 -> 토큰 가져옴
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDToken { idToken, error in
            if let error = error {
                print("🔴Firebase idToken 실패 = 파베 기존 유저 아님", error.localizedDescription)
                return
            }
            guard let idToken = idToken else { return }
            print("🟢Firebase idToken 성공 ->>>", idToken)
            UserDefaultsHelper.standard.idToken = idToken
        }
    }
}
