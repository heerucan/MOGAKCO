//
//  Font+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case bold = "Pretendard-Bold"
        case semibold = "Pretendard-Semibold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        
        var name: String {
            return self.rawValue
        }
    }
}
