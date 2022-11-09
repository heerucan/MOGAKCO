//
//  NicknameViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class NicknameViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let nicknameView = NicknameView()
    private let nicknameViewModel = NicknameViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func setupDelegate() {
        nicknameView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = NicknameViewModel.Input(nicknameText: nicknameView.textField.rx.text, nicknameTap: nicknameView.reuseView.okButton.rx.tap)
        let output = nicknameViewModel.transform(input)
        
        nicknameViewModel.nickname // Output
            .asDriver(onErrorJustReturn: "")
            .drive(nicknameView.textField.rx.text)
            .disposed(by: disposeBag)
                
        // 닉네임 입력하는 것 -> Input
        nicknameView.textField.rx.text
            .orEmpty
            .bind(to: nicknameViewModel.nickname)
            .disposed(by: disposeBag)
        
        // 닉네임 입력 후 유효성 검사 -> ? 뷰모델에 map 내의 count 부분을 넣어줄 수 있나?
        nicknameView.textField.rx.text // Input
            .orEmpty
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, ""))
            .map { (vc, value) in
                (value.count > 10 || value.count == 0) ? false : true
            }
            .drive(nicknameView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        // 그다음 버튼 탭하는 것 -> Input
        nicknameView.reuseView.okButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.pushBirthView()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushBirthView() {
        let viewController = BirthViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITextField Delegate

extension NicknameViewController: UITextFieldDelegate { }
