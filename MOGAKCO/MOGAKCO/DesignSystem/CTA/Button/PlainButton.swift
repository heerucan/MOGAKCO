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

final class PlainButton: UIButton {
    
    // MARK: - Enum
    
    @frozen
    enum PlainButtonType {
        case fill // 배경색있는
        case outline // 테두리있는
        case grayLine
        case cancel // 취소버튼
        
        fileprivate var titleColor: UIColor {
            switch self {
            case .fill:
                return .white
            case .outline:
                return Color.green
            case .grayLine:
                return Color.black
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
            case .cancel:
                return .clear
            }
        }
        
        fileprivate var borderWidth: CGFloat {
            switch self {
            case .fill, .cancel:
                return 0
            case .outline, .grayLine:
                return 1
            }
        }
        
        fileprivate var selectedColor: UIColor {
            switch self {
            case .fill:
                return Color.green
            case .outline:
                return Color.green
            case .grayLine:
                return Color.green
            case .cancel:
                return Color.gray2
            }
        }
        
        fileprivate var selectedTitleColor: UIColor {
            switch self {
            case .fill, .outline, .grayLine: return .white
            default: return Color.black
            }
        }
    }
    
    // MARK: - Property
    
    private var height: HeightType = .h48
    var type: PlainButtonType = .fill
    
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
    
    var isSelect: Bool = false {
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
        let titleColor: UIColor = isEnable ? .white : Color.gray3
        setTitleColor(titleColor, for: .normal)
        backgroundColor = isEnable ? type.backgroundColor : Color.gray6
    }
    
    func configureSelectedColor(type: PlainButtonType) {
        backgroundColor = isSelect ? type.selectedColor : type.backgroundColor
        setTitleColor(type.selectedTitleColor, for: .normal)
        makeCornerStyle(width: 0, color: type.borderColor.cgColor, radius: 8)
    }
    
    func configureSelected(_ type: PlainButtonType) {
        backgroundColor = type.selectedColor
        setTitleColor(type.selectedTitleColor, for: .normal)
        makeCornerStyle(width: type.borderWidth, color: type.borderColor.cgColor, radius: 8)
    }
    
    func configureUnselected(_ type: PlainButtonType) {
        backgroundColor = type.backgroundColor
        setTitleColor(type.titleColor, for: .normal)
        makeCornerStyle(width: type.borderWidth, color: type.borderColor.cgColor, radius: 8)
    }
}
