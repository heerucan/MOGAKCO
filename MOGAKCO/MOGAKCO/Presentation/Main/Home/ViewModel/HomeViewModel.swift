//
//  HomeViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import Foundation

import RxSwift
import RxCocoa
import CoreLocation

final class HomeViewModel: ViewModelType {
    
    let ssacCoordinate = CLLocationCoordinate2D(latitude: Matrix.ssacLat, longitude: Matrix.ssacLong)
    let tagList = Observable.just(["전체", "남자", "여자"])
    lazy var locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(value: ssacCoordinate)
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let tagList: Observable<[String]>
    }
    
    func transform(_ input: Input) -> Output {
        let tagList = Observable.just(["전체", "남자", "여자"])
        return Output(tap: input.tap, tagList: tagList)
    }
}
