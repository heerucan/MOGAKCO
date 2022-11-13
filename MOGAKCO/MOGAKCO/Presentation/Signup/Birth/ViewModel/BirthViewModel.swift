//
//  BirthViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

final class BirthViewModel: ViewModelType {
    
    struct Input {
        let date: ControlProperty<Date>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let date: Driver<[String]>
        let tap: Observable<Bool>
        let dateValid: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let dateValid = input.date
            .map { value in
                value.checkAge() < 17 ? false : true
            }
            .asDriver(onErrorJustReturn: false)
        
        let date = input.date
            .map { value in
                [value.toString(format: .year),
                 value.toString(format: .month),
                 value.toString(format: .day)]
            }
            .asDriver(onErrorJustReturn: [""])
        
        let nextTap = input.tap
            .withLatestFrom(dateValid)
            .share()
        
        return Output(date: date, tap: nextTap, dateValid: dateValid)
    }
}
