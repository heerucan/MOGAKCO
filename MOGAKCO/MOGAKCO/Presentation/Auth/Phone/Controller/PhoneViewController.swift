//
//  PhoneViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import UIKit

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
    
    // MARK: - UI & Layout
    
    override func setupDelegate() {
        phoneView.setupDelegate(self)
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
            .bind { (vc, value) in
                vc.phoneView.textField.backWards(with: value, 13)
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
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITextField Delegate

extension PhoneViewController: UITextFieldDelegate { }
