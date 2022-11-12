//
//  String+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd T HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.date(from: self)!
    }
    
    @frozen
    enum Regex {
        case email
        case phone
        
        var regexStyle: String {
            switch self {
            case .email:
                return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            case .phone:
                return "^01([0-9]?)-?([0-9]{3,4})-?([0-9]{4})$"
            }
        }
    }
    
    func checkRegex(regex: Regex) -> Bool {
        let regex = regex.regexStyle
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
