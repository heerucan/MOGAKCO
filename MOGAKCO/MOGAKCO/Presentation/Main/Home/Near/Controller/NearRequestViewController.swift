//
//  NearRequestViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class NearRequestViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let requestView = RequestView()
    private let nearViewModel = NearViewModel()

    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
   
    override func configureLayout() {
        
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}
