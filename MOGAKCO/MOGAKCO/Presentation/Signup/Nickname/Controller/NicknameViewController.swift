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
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .common).then {
        $0.viewController = self
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = nicknameView
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
        
        let input = NicknameViewModel.Input(
            nicknameText: nicknameView.textField.rx.text,
            tap: nicknameView.reuseView.okButton.rx.tap)
        let output = nicknameViewModel.transform(input)
        
        output.nicknameText
            .drive(nicknameView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.nicknameValid
            .drive(nicknameView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc, isValid) in
                isValid ? vc.pushBirthView() : vc.showToast(Toast.nickTypeError.message)
            }
            .disposed(by: disposeBag)
        
        output.userDefaults
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind { (vc, nickname) in
                UserDefaultsHelper.standard.nickname = nickname
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushBirthView() {
        let vc = BirthViewController()
        self.transition(vc, .push)
    }
}
