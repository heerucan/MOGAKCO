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
    let lineHeight: CGFloat
}

@frozen
enum Font {
    case display1
    case title1
    case title2
    case title3
    case title4
    case title5
    case title6
    case body1
    case body2
    case body3
    case body4
    case caption
    case onboard1
    case onboard2
    
    fileprivate var property: FontStyle {
        switch self {
        case .display1:
            return FontStyle(font: .regular, size: 20, lineHeight: 25.6)
        case .title1:
            return FontStyle(font: .medium, size: 16, lineHeight: 25.6)
        case .title2:
            return FontStyle(font: .regular, size: 16, lineHeight: 25.6)
        case .title3:
            return FontStyle(font: .medium, size: 14, lineHeight: 22.4)
        case .title4:
            return FontStyle(font: .regular, size: 14, lineHeight: 22.4)
        case .title5:
            return FontStyle(font: .medium, size: 12, lineHeight: 18)
        case .title6:
            return FontStyle(font: .regular, size: 12, lineHeight: 18)
        case .body1:
            return FontStyle(font: .medium, size: 16, lineHeight: 29.6)
        case .body2:
            return FontStyle(font: .regular, size: 16, lineHeight: 29.6)
        case .body3:
            return FontStyle(font: .regular, size: 14, lineHeight: 23.8)
        case .body4:
            return FontStyle(font: .regular, size: 12, lineHeight: 21.6)
        case .caption:
            return FontStyle(font: .regular, size: 10, lineHeight: 16)
        case .onboard1:
            return FontStyle(font: .medium, size: 24, lineHeight: 38.4)
        case .onboard2:
            return FontStyle(font: .regular, size: 24, lineHeight: 38.4)
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
