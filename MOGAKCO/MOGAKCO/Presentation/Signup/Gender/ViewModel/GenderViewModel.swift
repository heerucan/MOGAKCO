//
//  GenderViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

import RxSwift
import RxCocoa

final class GenderViewModel: ViewModelType {
    
    struct Input {
        let genderIndex: ControlEvent<IndexPath>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let gender: Observable<[Gender]>
        let tap: ControlEvent<Void>
        let genderIndex: ControlEvent<IndexPath>
    }
    
    func transform(_ input: Input) -> Output {
        let genderIndex = input.genderIndex
        let genderList = Observable.just(GenderData().list)
            
        return Output(gender: genderList, tap: input.tap, genderIndex: genderIndex)
    }
}
