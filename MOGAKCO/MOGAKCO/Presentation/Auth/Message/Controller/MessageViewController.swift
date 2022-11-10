//
//  MessageViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

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
    
    // MARK: - UI & Layout
    
    override func setupDelegate() {
        messageView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = MessageViewModel.Input(messageTap: messageView.reuseView.okButton.rx.tap)
        let output = messageViewModel.transform(input)
        
        messageViewModel.messageNumber // Output
            .asDriver(onErrorJustReturn: "")
            .drive(messageView.textField.rx.text)
            .disposed(by: disposeBag)
                
        messageView.textField.rx.text
            .orEmpty
            .bind(to: messageViewModel.messageNumber)
            .disposed(by: disposeBag)
        
        messageView.textField.rx.text // Input
            .orEmpty
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, ""))
            .map { (vc, value) in
                value.count == 6 ? true : false
            }
            .drive(messageView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.messageTap
            .withUnretained(self)
            .bind { vc, _ in
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

// MARK: - UITextField Delegate

extension MessageViewController: UITextFieldDelegate { }
