//
//  MyViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyViewController: BaseViewController {
    
    // MARK: - Property
    
    let button = UIButton().then {
        $0.setTitle("탈퇴", for: .normal)
    }
    
    private let navigationBar = PlainNavigationBar(type: .my)
    
    // MARK: - Initializer

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = .orange
        navigationBar.backgroundColor = .yellow
    }
   
    override func configureLayout() {
        view.addSubviews([navigationBar])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }    
    
    // MARK: - Bind
    
    override func bindViewModel() {

//        let input = MyDetailViewModel.Input()
//        let output = myDetailViewModel.transform(input)

    }
    
    // MARK: - Network

}
