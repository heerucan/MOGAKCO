//
//  Font.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

struct FontStyle {
    let font: UIFont.FontType
    let size: CGFloat
    let kern: CGFloat
    let lineHeight: CGFloat?
}

enum Font {
    case title1
    case title2
    case title3
    case body1
    case body2
    case body3
    case body4
    case body5
    case body6
    case body7
    case body8
    case body9
    case body10
    
    fileprivate var property: FontStyle {
        switch self {
        case .title1:
            return FontStyle(font: .semibold, size: 20, kern: -0.3, lineHeight: nil)
        case .title2:
            return FontStyle(font: .semibold, size: 24, kern: -0.3, lineHeight: nil)
        case .title3:
            return FontStyle(font: .semibold, size: 25, kern: -0.3, lineHeight: nil)
        case .body1:
            return FontStyle(font: .semibold, size: 18, kern: -0.3, lineHeight: nil)
        case .body2:
            return FontStyle(font: .medium, size: 18, kern: -0.3, lineHeight: nil)
        case .body3:
            return FontStyle(font: .semibold, size: 16, kern: -0.3, lineHeight: 25)
        case .body4:
            return FontStyle(font: .medium, size: 15, kern: -0.3, lineHeight: 21)
        case .body5:
            return FontStyle(font: .regular, size: 15, kern: -0.3, lineHeight: 21)
        case .body6:
            return FontStyle(font: .bold, size: 14, kern: -0.3, lineHeight: nil)
        case .body7:
            return FontStyle(font: .regular, size: 14, kern: -0.3, lineHeight: nil)
        case .body8:
            return FontStyle(font: .regular, size: 13, kern: -0.3, lineHeight: 22)
        case .body9:
            return FontStyle(font: .semibold, size: 15, kern: -0.3, lineHeight: 22)
        case .body10:
            return FontStyle(font: .medium, size: 12, kern: -0.3, lineHeight: 10)
        }
    }
}

extension Font {
    var font: UIFont {
        guard let font = UIFont(name: property.font.name, size: property.size) else {
            return UIFont()
        }
        return font
    }
}
