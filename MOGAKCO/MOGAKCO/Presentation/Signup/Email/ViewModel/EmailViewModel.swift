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
    
    let email = PublishRelay<String>()
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
