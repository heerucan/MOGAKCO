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
        
    struct Input {
        let phoneText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneText: Observable<String>
        let tap: ControlEvent<Void>
        let phoneValid: Observable<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let text = input.phoneText
            .orEmpty
            .withUnretained(self)
            .map { (vm, value) in
                vm.addHyphen(text: value)
            }
            .share()
        
        let phoneValid = input.phoneText
            .orEmpty
            .map { value in
                value.count > 13 ? false : true &&
                value.checkRegex(regex: .phone)
            }
            .share()
        
        return Output(phoneText: text, tap: input.tap, phoneValid: phoneValid)
    }
    
    func addHyphen(text: String) -> String {
        let phoneText = text.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
        return phoneText
    }
}
