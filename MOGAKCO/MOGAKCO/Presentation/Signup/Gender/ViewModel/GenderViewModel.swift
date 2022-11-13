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
    
    let signResult: PublishSubject<GenericResponse<VoidType>> = PublishSubject()
    
    struct Input {
        let genderIndex: ControlEvent<IndexPath>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let gender: Observable<[Gender]>
        let tap: Observable<ControlEvent<IndexPath>.Element>
        let genderIndex: ControlEvent<IndexPath>
    }
    
    func transform(_ input: Input) -> Output {
        let genderIndex = input.genderIndex
        let genderList = Observable.just(GenderData().list)
        
        let nextTap = input.tap
            .withLatestFrom(genderIndex)
        
        return Output(gender: genderList, tap: nextTap, genderIndex: genderIndex)
    }
}
