//
//  MessageView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

import SnapKit
import Then

final class MessageView: BaseView {
    
    // MARK: - Property
    
    let reuseView = AuthReuseView(Matrix.messageTitle).then {
        $0.buttonTitle = Matrix.messageButtonTitle
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [textField, resendButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    lazy var textField = PlainTextField(.line).then {
        $0.placeholder = Matrix.messagePlaceholder
        $0.clearButtonMode = .never
        $0.keyboardType = .numberPad
        $0.addSubview(timerLabel)
    }
    
    let resendButton = PlainButton(.fill).then {
        $0.title = "재전송"
    }
    
    let timerLabel = UILabel().then {
        $0.text = "05:00"
        $0.font = Font.title3.font
        $0.textColor = Color.green
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([reuseView,
                     stackView])
        
        reuseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(297)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        resendButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(23)
        }
    }
    
    func setupDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
}
