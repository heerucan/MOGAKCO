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
    
    let genderList = Observable.of(GenderData().list)
    
    struct Input {
        let genderTap: ControlEvent<Void>
    }
    
    struct Output {
        let gender: Observable<[Gender]>
        let genderTap: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        return Output(gender: genderList, genderTap: input.genderTap)
    }
}
