//
//  MessageViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

import RxSwift
import RxCocoa

final class MessageViewModel: ViewModelType {
        
    struct Input {
        let messageText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let messageText: ControlProperty<String>
        let tap: ControlEvent<Void>
        let messageValid: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let messageValid = input.messageText
            .orEmpty
            .map { value in
                value.count == 6 ? true : false
            }
            .asDriver(onErrorJustReturn: false)
        
        let text = input.messageText.orEmpty
        
        return Output(messageText: text, tap: input.tap, messageValid: messageValid)
    }
}
