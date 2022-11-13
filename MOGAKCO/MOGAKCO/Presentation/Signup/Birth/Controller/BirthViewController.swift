//
//  BirthViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class BirthViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let birthView = BirthView()
    private let birthViewModel = BirthViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = BirthViewModel.Input(date: birthView.datePicker.rx.date, tap: birthView.reuseView.okButton.rx.tap)
        let output = birthViewModel.transform(input)
        
        output.dateValid
            .skip(1)
            .asDriver()
            .drive(birthView.reuseView.okButton.rx.isEnable)
            .disposed(by: disposeBag)
        
        output.date
            .skip(1)
            .drive { [weak self] value in
                self?.birthView.yearTextField.text = value[0]
                self?.birthView.monthTextField.text = value[1]
                self?.birthView.dayTextField.text = value[2]
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc, isValid) in
                if isValid {
                    vc.pushEmailView()
                    UserDefaultsHelper.standard.birthday = vc.birthView.datePicker.date.toString(format: .full)
                }  else {
                    vc.showToast(.birthTypeError)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushEmailView() {
        let vc = EmailViewController()
        self.transition(vc, .push)
    }
}
