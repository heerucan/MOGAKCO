//
//  HomeViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import Foundation

final class HomeViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    
    // MARK: - Property
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .red
    }
    
    override func configureLayout() {
        
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}
