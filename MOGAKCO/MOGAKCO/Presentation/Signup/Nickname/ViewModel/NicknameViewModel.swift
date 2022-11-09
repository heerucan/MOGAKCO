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
    
    let nickname = PublishRelay<String>()
    let isNicknameValid = BehaviorRelay(value: false)
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let nicknameTap: ControlEvent<Void>
    }
    
    struct Output {
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
