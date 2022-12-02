//
//  BaseView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

class BaseView: UIView, BaseMethodProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        setupDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    func configureLayout() { }
    func bindViewModel() { }
    func setupDelegate() { }
}
