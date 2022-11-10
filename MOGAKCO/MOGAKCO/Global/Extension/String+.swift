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
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.date(from: self)!
    }
}
