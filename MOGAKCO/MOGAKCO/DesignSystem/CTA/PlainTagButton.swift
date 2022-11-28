//
//  PlainTagButton.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

/**
 PlainTagButton
 - 스터디 검색 태그 버튼 시스템
 */

// MARK: - Enum

enum TagButtonType {
    case red
    case gray
    case green
    
    var borderColor: UIColor {
        switch self {
        case .red:
            return Color.error
        case .gray:
            return Color.gray4
        case .green:
            return Color.green
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .red:
            return Color.error
        case .gray:
            return Color.black
        case .green:
            return Color.green
        }
    }
}

final class PlainTagButton: UIButton {
    
    // MARK: - Property
    
    var type: TagButtonType = .red {
        didSet {
            configureUI(type: type)
            configureLayout(type: type)
        }
    }
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
        
    // MARK: - Initializer
    
    init(_ type: TagButtonType) {
        super.init(frame: .zero)
        configureUI(type: type)
        configureLayout(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: TagButtonType) {
        titleLabel?.font = Font.title4.font
        setTitleColor(type.textColor, for: .normal)
        setTitleColor(Color.gray4, for: .highlighted)
        backgroundColor = .white
        makeCornerStyle(width: 1, color: type.borderColor.cgColor, radius: 8)
    }
    
    private func configureLayout(type: TagButtonType = .green) {
        snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        var configuration = PlainButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        self.configuration = configuration

        if type == .green {
            var configuration = PlainButton.Configuration.plain()
            configuration.image = Icon.closeSmall
            configuration.imagePlacement = .trailing
            configuration.imagePadding = 4
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
            self.configuration = configuration
        } 
    }
}
