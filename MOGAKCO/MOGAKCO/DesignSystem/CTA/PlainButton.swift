//
//  H48Button.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

/**
 PlainButton
 - 기본 버튼 시스템
 */

// MARK: - Enum

@frozen
enum HeightType {
    case h48
    case h32
    case h40
    
    fileprivate var height: CGFloat {
        switch self {
        case .h48:
            return 48
        case .h32:
            return 32
        case .h40:
            return 40
        }
    }
}

@frozen
enum PlainButtonType {
    case fill // 배경색있는
    case outline // 테두리있는
    case grayLine
    case cancel // 취소버튼
    case redOutline
    
    fileprivate var titleColor: UIColor {
        switch self {
        case .fill:
            return .white
        case .outline:
            return Color.green
        case .grayLine:
            return Color.black
        case .redOutline:
            return Color.error
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
        case .grayLine:
            return .white
        case .redOutline:
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
        case .grayLine:
            return Color.gray4
        case .redOutline:
            return Color.error
        case .cancel:
            return .clear
        }
    }
    
    fileprivate var borderWidth: CGFloat {
        switch self {
        case .fill, .cancel:
            return 0
        case .outline, .grayLine, .redOutline:
            return 1
        }
    }
    
    fileprivate var selectedColor: UIColor {
        switch self {
        case .fill:
            return Color.green
        case .outline, .redOutline:
            return .white
        case .grayLine:
            return Color.green
        case .cancel:
            return Color.gray2
        }
    }
    
    fileprivate var selectedTitleColor: UIColor {
        switch self {
        case .fill: return .white
        default: return Color.black
        }
    }
}

final class PlainButton: UIButton {
    
    // MARK: - Property
    
    private var height: HeightType = .h48
    private var type: PlainButtonType = .fill
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
        
    var isEnable: Bool = false {
        didSet {
            configureDisableColor(type: type)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            configureSelectedColor(type: type)
        }
    }
        
    // MARK: - Initializer
    
    init(_ type: PlainButtonType, height: HeightType) {
        super.init(frame: .zero)
        configureUI(type: type)
        configureLayout(height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: PlainButtonType) {
//        titleEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        titleLabel?.font = Font.body3.font
        setTitleColor(type.titleColor, for: .normal)
        backgroundColor = type.backgroundColor
        makeCornerStyle(width: type.borderWidth, color: type.borderColor.cgColor, radius: 8)
        setTitleColor(Color.gray4, for: .highlighted)
    }
    
    private func configureLayout(height: HeightType = .h48) {
        snp.makeConstraints { make in
            make.height.equalTo(height.height)
        }
    }
    
    private func configureDisableColor(type: PlainButtonType) {
//        isUserInteractionEnabled = isEnable ? true : false
        let titleColor: UIColor = isEnable ? .white : Color.gray3
        setTitleColor(titleColor, for: .normal)
        backgroundColor = isEnable ? type.backgroundColor : Color.gray6
    }
    
    private func configureSelectedColor(type: PlainButtonType) {
        backgroundColor = isSelected ? type.selectedColor : type.backgroundColor
        setTitleColor(type.selectedTitleColor, for: .selected)
        makeCornerStyle(width: 0, color: type.borderColor.cgColor, radius: 8)
    }
}
