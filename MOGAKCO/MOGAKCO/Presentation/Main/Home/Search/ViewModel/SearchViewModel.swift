//
//  SearchViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    let searchResponse = BehaviorSubject<[String]>(value: ["아무거나", "SeSAC", "코딩", "Swift", "SwiftUI", "CoreData", "Python", "Java"])
    
    struct Input {
        
    }
    
    struct Output {
        let searchResponse: BehaviorSubject<[String]>
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output(searchResponse: searchResponse)
    }
}
