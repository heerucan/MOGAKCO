//
//  PhoneViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PhoneViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let phoneView = PhoneView()
    private let phoneViewModel = PhoneViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = phoneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = PhoneViewModel.Input(phoneText: phoneView.textField.rx.text, tap: phoneView.reuseView.okButton.rx.tap)
        let output = phoneViewModel.transform(input)
        
        output.phoneText
            .bind(to: phoneView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.phoneValid
            .drive(phoneView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.phoneText
            .withUnretained(self)
            .observe(on:MainScheduler.asyncInstance)
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .bind { (vc, number) in
                vc.phoneView.textField.backWards(with: number, 13)
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (vc, value) in
                if value {
                    // 여기서 문자 메시지를 받기
                    vc.requestMessage(vc.phoneView.textField.text ?? "")
                } else {
                    vc.showToast(.phoneTypeError)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushMessageView() {
        let viewController = MessageViewController()
        self.transition(viewController, .push)
    }
}

// MARK: - Firebase Auth

extension PhoneViewController {
    func requestMessage(_ phoneNumber: String) {
        Auth.auth().languageCode = "ko"
        PhoneAuthProvider.provider().verifyPhoneNumber("+82 \(phoneNumber)", uiDelegate: nil) { [weak self] verificationID, error in
            guard let self = self else { return }
            if let error = error {
                print("🔴Verfiy 실패", error.localizedDescription)
                // TODO: - 여기서 과도한 요청 시에 .overRequestError로 케이스 처리 해줘야 함
                self.showToast(.etcAuthError)
                return
            }
            
            guard let verificationID = verificationID else { return }
            print("🟢VerficationID ->>>", verificationID)
            UserDefaults.standard.set(verificationID, forKey: Matrix.verificationID)
            self.pushMessageView()
        }
    }
}
