//
//  HomeViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        return Output(tap: input.tap)
    }
}
