//
//  Date+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func checkAge() -> Int {
        let gap = Calendar.current.dateComponents([.year], from: self, to: Date.now).year ?? 0
        return gap
    }
}
