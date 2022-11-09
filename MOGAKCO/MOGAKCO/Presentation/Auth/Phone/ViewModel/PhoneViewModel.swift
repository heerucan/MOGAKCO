//
//  PhoneViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa

final class PhoneViewModel: ViewModelType {
    
    let phoneNumber = PublishRelay<String>()
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        return Output(tap: input.tap)
    }
    
    func checkPhoneNumber(with phoneText: String) -> Bool {
        let regex = "^01([0-9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phoneText.addHyphen())
    }
    
    func addHyphen(text: String) {
        let phoneText = text.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
        phoneNumber.accept(phoneText)
    }
}
