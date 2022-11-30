//
//  PlainRequestButton.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/30.
//

import UIKit

/**
 PlainTagButton
 - 스터디 검색 태그 버튼 시스템
 */

final class PlainRequestButton: UIButton {
    
    // MARK: - Enum

    enum RequestButtonType {
        case request
        case accept
        
        fileprivate var backgroundColor: UIColor {
            switch self {
            case .request:
                return Color.error
            case .accept:
                return Color.success
            }
        }
        
        fileprivate var title: String {
            switch self {
            case .request:
                return "요청하기"
            case .accept:
                return "수락하기"
            }
        }
    }
    
    // MARK: - Property
    
    var type: RequestButtonType = .request {
        didSet {
            configureUI(type: type)
        }
    }
 
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: RequestButtonType) {
        setTitle(type.title, for: .normal)
        titleLabel?.font = Font.title3.font
        setTitleColor(.white, for: .normal)
        setTitleColor(Color.gray4, for: .highlighted)
        backgroundColor = type.backgroundColor
        makeCornerStyle(width: 0, radius: 8)
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
