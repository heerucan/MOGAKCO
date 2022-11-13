//
//  NicknameViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let nicknameText: Driver<String>
        let tap: Observable<Bool>
        let userDefaults: Observable<ControlProperty<String>.Element>
        let nicknameValid: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let checkValid = input.nicknameText.orEmpty
            .map { value in
                (value.count > 10 || value.count == 0) ? false : true
            }
            .asDriver(onErrorJustReturn: false)
        
        let text = input.nicknameText
            .orEmpty
            .asDriver(onErrorJustReturn: "")
        
        let nextTap = input.tap
            .withLatestFrom(checkValid)
            .share()
            
        let userDefaults = input.tap
            .withLatestFrom(text)
            .share()
        
        return Output(nicknameText: text, tap: nextTap, userDefaults: userDefaults, nicknameValid: checkValid)
    }
}
