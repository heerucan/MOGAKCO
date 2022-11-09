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
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func setupDelegate() {
        phoneView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = PhoneViewModel.Input(tap: phoneView.reuseView.okButton.rx.tap)
        let output = phoneViewModel.transform(input)
        
        phoneViewModel.phoneNumber
            .withUnretained(self)
            .bind { (vc, value) in
                self.phoneView.textField.text = value
            }.disposed(by: disposeBag)
        
        phoneView.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.phoneViewModel.addHyphen(text: value)
                if value.count > 13 {
                    vc.phoneView.textField.deleteBackward()
                }
            }
            .disposed(by: disposeBag)
        
        phoneView.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .map { (vc, value) in
                vc.phoneViewModel.checkPhoneNumber(with: value)
            }
            .bind(to: phoneView.reuseView.okButton.rx.isEnabled)
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
