//
//  MyViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class MyViewModel: ViewModelType {
    
    let myProfileList = BehaviorSubject<[MyProfile]>(value: MyProfileData().getMyProfileList())
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let myProfileList: BehaviorSubject<[MyProfile]>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    func transform(_ input: Input) -> Output {
        let itemSelected = input.itemSelected
        
        return Output(myProfileList: myProfileList, itemSelected: itemSelected)
    }
}
