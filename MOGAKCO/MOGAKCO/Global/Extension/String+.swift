//
//  String+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

extension String {
    func toDate(from dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date {
        let stringDate = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.date(from: stringDate)!
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
    
    subscript(idx: Int) -> String? {
        
        // 인덱스는 항상 배열 count보다 1씩 작아서 0..<count
        // idx가 저 범위 내에 없으면 nil 반환
        guard (0..<count).contains(idx) else {
            return nil
        }
        
        // 첫 번째 캐릭터로부터 얼마나 떨어져있냐?를 result로 반환
        let result = index(startIndex, offsetBy: idx)
        return String(self[result])
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ?  self[index] : nil
    }
}
