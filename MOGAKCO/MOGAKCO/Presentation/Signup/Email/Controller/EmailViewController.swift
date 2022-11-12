//
//  EmailViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class EmailViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let emailView = EmailView()
    private let emailViewModel = EmailViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = emailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = EmailViewModel.Input(emailText: emailView.textField.rx.text, tap: emailView.reuseView.okButton.rx.tap)
        let output = emailViewModel.transform(input)
       
        output.emailText
            .bind(to: emailView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.emailVaild
            .drive(emailView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc, isValid) in
                isValid ? vc.pushGenderView() : vc.showToast(.emailTypeError)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushGenderView() {
        let viewController = GenderViewController()
        self.transition(viewController, .push)
    }
}
