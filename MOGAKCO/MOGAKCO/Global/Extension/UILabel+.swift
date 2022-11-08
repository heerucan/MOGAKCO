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
    
    func lineNumber(labelWidth: CGFloat) -> Int {
        let boundingRect = self.text!.boundingRect(with: .zero,
                                                   options: [.usesFontLeading],
                                                   attributes: [.font: self.font!],
                                                   context: nil)
        return Int(boundingRect.width / labelWidth + 1)
    }
}
