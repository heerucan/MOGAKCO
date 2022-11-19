//
//  NicknameView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import UIKit

import SnapKit
import Then

final class NicknameView: BaseView {
    
    // MARK: - Property
    
    let reuseView = AuthReuseView(Matrix.nicknameTitle, topInset: 185).then {
        $0.buttonTitle = Matrix.nextButtonTitle
        $0.okButton.isEnable = false
        $0.configureLayout(topInset: 185)
    }
    
    var textField = PlainTextField(.line).then {
        $0.placeholder = Matrix.nicknamePlaceholder
        $0.becomeFirstResponder()
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
