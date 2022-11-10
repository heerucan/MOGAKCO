//
//  EmailView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import UIKit

import SnapKit
import Then

final class EmailView: BaseView {
    
    // MARK: - Property
    
    let reuseView = AuthReuseView(Matrix.emailTitle, subtitle: Matrix.emailSubtitle).then {
        $0.buttonTitle = Matrix.nextButtonTitle
    }
    
    var textField = PlainTextField(.line).then {
        $0.placeholder = Matrix.emailPlaceholder
        $0.keyboardType = .emailAddress
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
