//
//  EmailViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

final class EmailViewModel: ViewModelType {
        
    struct Input {
        let emailText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let emailText: ControlProperty<String>
        let tap:  Observable<Bool>
        let userDefaults: Observable<ControlProperty<String>.Element>
        let emailVaild: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let emailVaild = input.emailText
            .orEmpty
            .map { value in
                value.checkRegex(regex: .email)
            }
            .asDriver(onErrorJustReturn: false)
        
        let text = input.emailText
            .orEmpty
        
        let nextTap = input.tap
            .withLatestFrom(emailVaild)
            .share()
        
        let userDefaults = input.tap
            .withLatestFrom(text)
            .share()
        
        return Output(emailText: text, tap: nextTap, userDefaults: userDefaults,  emailVaild: emailVaild)
    }
}
