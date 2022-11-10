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
        let tap: ControlEvent<Void>
        let nicknameValid: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let checkValid = input.nicknameText
            .orEmpty
            .map { value in
                (value.count > 10 || value.count == 0) ? false : true
            }
            .asDriver(onErrorJustReturn: false)
        
        let text = input.nicknameText
            .orEmpty
            .asDriver(onErrorJustReturn: "")
        
        return Output(nicknameText: text, tap: input.tap, nicknameValid: checkValid)
    }
}
