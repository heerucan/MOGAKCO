//
//  TextFieldType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

// MARK: - Enum

@frozen
enum TextFieldType {
    case line
    case fill
    
    var backgroundColor: UIColor {
        switch self {
        case .line:
            return .white
        case .fill:
            return Color.gray1
        }
    }
    
    var font: UIFont {
        switch self {
        case .line:
            return Font.title4.font
        case .fill:
            return Font.body3.font
        }
    }
    
    var placeholderColor: UIColor {
        switch self {
        case .line:
            return UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
        case .fill:
            return Color.gray7
        }
    }
}
