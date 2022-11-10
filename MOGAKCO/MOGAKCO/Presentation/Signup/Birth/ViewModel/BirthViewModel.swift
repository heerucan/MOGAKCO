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
        let tap: ControlEvent<Void>
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
                [value.toString(format: "yyyy"),
                value.toString(format: "MM"),
                value.toString(format: "dd")]
            }
            .asDriver(onErrorJustReturn: [""])
        
        return Output(date: date, tap: input.tap, dateValid: dateValid)
    }
}
