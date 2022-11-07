//
//  H48Button.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

final class H48Button: UIButton {
    
    // MARK: - Enum
    
    enum ButtonType {
        case fill // 배경색있는
        case outline // 테두리있는
        case cancel // 취소버튼
        
        fileprivate var titleColor: UIColor {
            switch self {
            case .fill:
                return .white
            case .outline:
                return Color.green
            case .cancel:
                return Color.black
            }
        }
        
        fileprivate var backgroundColor: UIColor {
            switch self {
            case .fill:
                return Color.green
            case .outline:
                return .white
            case .cancel:
                return Color.gray2
            }
        }
        
        fileprivate var borderColor: UIColor {
            switch self {
            case .fill:
                return .clear
            case .outline:
                return Color.green
            case .cancel:
                return .clear
            }
        }
        
        fileprivate var borderWidth: CGFloat {
            switch self {
            case .fill:
                return 0
            case .outline:
                return 1
            case .cancel:
                return 0
            }
        }
    }
    
    // MARK: - Property
    
    var type: ButtonType = .fill
    
    var isDisabled: Bool = false {
        didSet {
            configureDisableColor(type: type)
        }
    }
        
    // MARK: - Initializer
    
    init(_ type: ButtonType, _ title: String) {
        super.init(frame: .zero)
        configureUI(type: type, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: ButtonType, title: String) {
        titleLabel?.font = Font.body3.font
        setTitle(title, for: .normal)
        setTitleColor(type.titleColor, for: .normal)
        backgroundColor = type.backgroundColor
        makeCornerStyle(radius: 8)
//        setTitleColor(Color., for: .highlighted)
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    private func configureDisableColor(type: ButtonType) {
        isUserInteractionEnabled = isDisabled ? false : true
        backgroundColor = isDisabled ? Color.gray6 : type.backgroundColor
    }
    
    // MARK: - Custom Method
}
