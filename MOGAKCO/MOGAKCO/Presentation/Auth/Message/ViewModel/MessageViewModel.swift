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
    
    let messageNumber = PublishRelay<String>()
    
    struct Input {
        let messageTap: ControlEvent<Void>
    }
    
    struct Output {
        let messageTap: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        return Output(messageTap: input.messageTap)
    }
}
