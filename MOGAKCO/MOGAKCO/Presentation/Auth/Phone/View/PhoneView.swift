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
    
    let reuseView = AuthReuseView(Matrix.Auth.phoneTitle, topInset: 169).then {
        $0.buttonTitle = Matrix.Button.phone
    }
    
    var textField = PlainTextField(.line).then {
        $0.placeholder = Matrix.Placeholder.phone
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
}
