//
//  MyDetailViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

final class MyDetailViewModel: ViewModelType {

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
