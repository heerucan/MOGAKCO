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
        let tap: Observable<Bool>
        let userDefaults: Observable<String>
        let phoneValid: Driver<Bool>
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
                (value.count < 13) ? false : true &&
                value.checkRegex(regex: .phone)
            }
            .asDriver(onErrorJustReturn: false)
        
        let nextTap = input.tap
            .withLatestFrom(phoneValid)
            .share()
        
        let userDefaults = input.tap
            .withLatestFrom(text)
            .share()
        
        return Output(phoneText: text, tap: nextTap, userDefaults: userDefaults, phoneValid: phoneValid)
    }
    
    func addHyphen(text: String) -> String {
        let phoneText = text.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
        return phoneText
    }
}
