//
//  String+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

extension String {
    func addHyphen() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
    }
}
