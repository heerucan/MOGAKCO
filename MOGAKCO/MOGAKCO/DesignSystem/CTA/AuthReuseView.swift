//
//  AuthReuseView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import UIKit

import SnapKit
import Then

/**
 AuthReuseView
 - 인증 단계 재사용뷰
 */

final class AuthReuseView: BaseView {
    
    // MARK: - Property
    
    var buttonTitle: String? {
        didSet {
            okButton.title = buttonTitle
        }
    }
    
    var topInset: CGFloat?
    
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
    
    let okButton = PlainButton(.fill, height: .h48)
    
    // MARK: - Initializer
    
    init(_ title: String, subtitle: String? = nil, topInset: CGFloat) {
        super.init(frame: .zero)
        configureLayout(topInset: topInset)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    // MARK: - UI & Layout
    
    func configureLayout(topInset: CGFloat) {
        addSubviews([titleLabel,
                     subtitleLabel,
                     okButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(347)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }
}
