//
//  Font+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

extension UIFont {
    @frozen
    enum FontType: String {
        case medium = "NotoSansKR-Medium"
        case regular = "NotoSansKR-Regular"
        
        var name: String {
            return self.rawValue
        }
    }
}
