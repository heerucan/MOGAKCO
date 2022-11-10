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
            .bind(to: phoneView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.phoneText
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind { (vc, number) in
                vc.phoneView.textField.backWards(with: number, 13)
                vc.verify(number)
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc,_) in
                vc.pushMessageView()
            }
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
    func verify(_ phoneNumber: String) {
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider
            .provider()
            .verifyPhoneNumber("+82 \(phoneNumber)", uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print(verificationID, "되긴 된다")
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
    }
}
