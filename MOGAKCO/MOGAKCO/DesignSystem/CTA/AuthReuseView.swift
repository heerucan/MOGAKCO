//
//  AuthReuseView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import UIKit

class AuthReuseView: BaseView {
    
    // MARK: - Property
    
    var buttonTitle: String? {
        didSet {
            okButton.title = buttonTitle
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.display1.font
        $0.textColor = Color.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = Font.body2.font
        $0.textColor = Color.gray7
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let okButton = PlainButton(.fill)
    
    // MARK: - Initializer
    
    init(_ title: String, subtitle: String? = nil) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([titleLabel,
                     subtitleLabel,
                     okButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(168)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(347)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
