//
//  Date+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

extension Date {
    
    @frozen
    enum DateFormat {
        case year
        case month
        case day
        case full
        case regular
        case special
        
        var text: String {
            switch self {
            case .year:
                return "yyyy"
            case .month:
                return "MM"
            case .day:
                return "dd"
            case .full:
                return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            case .regular:
                return "yyyy-MM-dd HH:mm:ss"
            case .special:
                return "HH:mm"
            }
        }
    }
    
    func toString(format: DateFormat = .full) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format.text
        return dateFormatter.string(from: self)
    }
    
    func checkAge() -> Int {
        let gap = Calendar.current.dateComponents([.year], from: self, to: Date.now).year ?? 0
        return gap
    }
}
