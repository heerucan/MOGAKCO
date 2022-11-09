//
//  PhoneView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

import IQKeyboardManagerSwift
import SnapKit
import Then

final class PhoneView: BaseView {
    
    // MARK: - Property
    
    let reuseView = AuthReuseView(Matrix.phoneTitle).then {
        $0.buttonTitle = Matrix.phoneButtonTitle
        $0.topInset = 169
    }
    
    var textField = PlainTextField(.line).then {
        $0.placeholder = Matrix.phonePlaceholder
        $0.keyboardType = .numberPad
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([reuseView,
                    textField])
        
        reuseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(297)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    func setupDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
}
