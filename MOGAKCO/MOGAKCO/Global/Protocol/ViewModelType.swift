//
//  ViewModelType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
