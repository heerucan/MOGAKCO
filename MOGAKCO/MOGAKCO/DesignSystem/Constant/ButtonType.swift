//
//  ButtonType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

// MARK: - Enum

@frozen
enum HeightType {
    case h48
    case h32
    case h40
    
    var height: CGFloat {
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
    
    var titleColor: UIColor {
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
    
    var backgroundColor: UIColor {
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
    
    var borderColor: UIColor {
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
    
    var borderWidth: CGFloat {
        switch self {
        case .fill, .cancel:
            return 0
        case .outline, .grayLine, .redOutline:
            return 1
        }
    }
    
    var selectedColor: UIColor {
        switch self {
        case .fill:
            return Color.green
        case .outline, .redOutline:
            return Color.green
        case .grayLine:
            return Color.green
        case .cancel:
            return Color.gray2
        }
    }
    
    var selectedTitleColor: UIColor {
        switch self {
        case .fill, .outline: return .white
        default: return Color.black
        }
    }
}
