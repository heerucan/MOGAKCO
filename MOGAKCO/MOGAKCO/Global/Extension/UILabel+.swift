//
//  UILabel+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

extension UILabel {
    func addProperty(_ color: UIColor? = Color.black, font: UIFont, _ range: String) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.foregroundColor,
                                          value: color!,
                                          range: (labelText as NSString).range(of: range))
            attributedString.addAttribute(.font,
                                          value: font,
                                          range: (labelText as NSString).range(of: range))
            attributedText = attributedString
        }
    }
}
