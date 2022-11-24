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
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .common).then {
        $0.viewController = self
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = emailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = EmailViewModel.Input(emailText: emailView.textField.rx.text,
                                         tap: emailView.reuseView.okButton.rx.tap)
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
                isValid ? vc.pushGenderView() : vc.showToast(ToastMatrix.emailTypeError.description)
            }
            .disposed(by: disposeBag)
        
        output.userDefaults
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind { (vc, email) in
                UserDefaultsHelper.standard.email = email
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushGenderView() {
        let vc = GenderViewController()
        self.transition(vc, .push)
    }
}
