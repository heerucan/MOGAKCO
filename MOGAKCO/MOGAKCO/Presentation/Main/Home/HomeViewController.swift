//
//  HomeViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class HomeViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
        
    // MARK: - Property
    
    let homeViewModel = HomeViewModel()
    let homeView = HomeView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .red
    }
    
    override func configureLayout() {
        
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(tap: button.rx.tap)
        let output = homeViewModel.transform(input)

    }
    

}
