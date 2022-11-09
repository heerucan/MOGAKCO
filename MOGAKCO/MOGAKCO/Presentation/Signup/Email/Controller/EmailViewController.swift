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
    
    // MARK: - UI & Layout
    
    override func setupDelegate() {
        emailView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = EmailViewModel.Input()
        let output = emailViewModel.transform(input)
        
    }
    
    // MARK: - Custom Method
    
    private func pushGenderView() {
        let viewController = GenderViewController()
        self.transition(viewController, .push)
    }
}

// MARK: - UITextField Delegate

extension EmailViewController: UITextFieldDelegate { }
