//
//  UITextView+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import UIKit

extension UITextView {
    func numberOfLine() -> Int {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
}
