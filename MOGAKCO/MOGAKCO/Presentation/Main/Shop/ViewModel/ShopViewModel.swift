//
//  ShopViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/29.
//

import Foundation

import RxSwift
import RxCocoa

final class ShopViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    // MARK: - Network
    
    func requestSave() {
        print("저장")
    }
}
