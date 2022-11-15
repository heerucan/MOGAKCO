//
//  MyViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

final class MyViewController: BaseViewController {
    
    let button = UIButton().then {
        $0.setTitle("탈퇴", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
   
    override func configureLayout() {
        view.addSubviews([button])
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }    
    
    // MARK: - Bind
    
    override func bindViewModel() {

//        let input = MyDetailViewModel.Input()
//        let output = myDetailViewModel.transform(input)

    }
    
    // MARK: - Network

}
