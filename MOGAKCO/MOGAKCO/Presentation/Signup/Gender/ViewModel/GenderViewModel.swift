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
    
    lazy var genderList = Observable.of(GenderData().list)
    
    struct Input { }
    
    struct Output {
        let gender: Observable<[Gender]>
    }
    
    func transform(_ input: Input) -> Output {
        return Output(gender: genderList)
    }
}
